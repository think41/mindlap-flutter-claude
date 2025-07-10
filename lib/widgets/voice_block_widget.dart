import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/content_block.dart';
import '../providers/app_provider.dart';

enum RecordingState { idle, recording, stopped, playing }

class VoiceBlockWidget extends StatefulWidget {
  final VoiceBlock block;

  const VoiceBlockWidget({
    super.key,
    required this.block,
  });

  @override
  State<VoiceBlockWidget> createState() => _VoiceBlockWidgetState();
}

class _VoiceBlockWidgetState extends State<VoiceBlockWidget> {
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  bool _isHovered = false;
  
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  RecordingState _recordingState = RecordingState.idle;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.block.description);
    _notesController = TextEditingController(text: widget.block.recordingNotes ?? '');
    
    _descriptionController.addListener(_updateBlock);
    _notesController.addListener(_updateBlock);
    
    // Set up audio player listeners
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _playbackPosition = position;
        });
      }
    });
    
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted && state.processingState == ProcessingState.completed) {
        setState(() {
          _recordingState = RecordingState.stopped;
          _playbackPosition = Duration.zero;
        });
      }
    });

    // Update state if block already has recording
    if (widget.block.hasRecording) {
      _recordingState = RecordingState.stopped;
      _recordingDuration = widget.block.duration ?? Duration.zero;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateBlock() {
    final appProvider = context.read<AppProvider>();
    final updatedBlock = widget.block.copyWith(
      description: _descriptionController.text,
      recordingNotes: _notesController.text,
    );
    appProvider.updateContentBlock(updatedBlock);
  }

  Future<void> _startRecording() async {
    try {
      if (kIsWeb) {
        // Web permissions are handled automatically by the browser
      } else {
        // Mobile permissions
        final permission = await Permission.microphone.request();
        if (permission != PermissionStatus.granted) {
          return;
        }
      }

      if (await _audioRecorder.hasPermission()) {
        const config = RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        );
        
        await _audioRecorder.start(config, path: 'temp_recording_${widget.block.id}.wav');
        setState(() {
          _recordingState = RecordingState.recording;
          _recordingDuration = Duration.zero;
        });
        
        // Start timer to track recording duration
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordingDuration = Duration(seconds: timer.tick);
            });
          }
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();
      if (path != null) {
        final appProvider = context.read<AppProvider>();
        final updatedBlock = widget.block.copyWith(
          audioPath: path,
          duration: _recordingDuration,
        );
        appProvider.updateContentBlock(updatedBlock);
        
        setState(() {
          _recordingState = RecordingState.stopped;
        });
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording() async {
    try {
      if (widget.block.audioPath != null) {
        // For web, decode the URL-encoded blob URL
        String audioPath = widget.block.audioPath!;
        if (audioPath.startsWith('blob%3A')) {
          audioPath = Uri.decodeFull(audioPath);
        }
        
        await _audioPlayer.setUrl(audioPath);
        
        setState(() {
          _recordingState = RecordingState.playing;
        });
        
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error playing recording: $e');
      setState(() {
        _recordingState = RecordingState.stopped;
      });
    }
  }

  Future<void> _pausePlayback() async {
    await _audioPlayer.pause();
    setState(() {
      _recordingState = RecordingState.stopped;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildRecordingControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Recording/Play button
          IconButton(
            onPressed: () {
              switch (_recordingState) {
                case RecordingState.idle:
                  _startRecording();
                  break;
                case RecordingState.recording:
                  _stopRecording();
                  break;
                case RecordingState.stopped:
                  if (widget.block.hasRecording) {
                    _playRecording();
                  } else {
                    _startRecording();
                  }
                  break;
                case RecordingState.playing:
                  _pausePlayback();
                  break;
              }
            },
            icon: Icon(
              _getRecordingIcon(),
              color: _getRecordingColor(),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Status and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getRecordingColor(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDuration(_recordingState == RecordingState.playing 
                      ? _playbackPosition 
                      : _recordingDuration),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Delete recording button (if recording exists)
          if (widget.block.hasRecording)
            IconButton(
              onPressed: () {
                final appProvider = context.read<AppProvider>();
                final updatedBlock = widget.block.copyWith(
                  audioPath: null,
                  audioData: null,
                  duration: null,
                );
                appProvider.updateContentBlock(updatedBlock);
                setState(() {
                  _recordingState = RecordingState.idle;
                  _recordingDuration = Duration.zero;
                  _playbackPosition = Duration.zero;
                });
              },
              icon: Icon(
                Icons.delete_outline,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getRecordingIcon() {
    switch (_recordingState) {
      case RecordingState.idle:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.stopped:
        return widget.block.hasRecording ? Icons.play_arrow : Icons.mic;
      case RecordingState.playing:
        return Icons.pause;
    }
  }

  Color _getRecordingColor() {
    switch (_recordingState) {
      case RecordingState.idle:
        return Colors.grey.shade600;
      case RecordingState.recording:
        return Colors.red;
      case RecordingState.stopped:
        return widget.block.hasRecording ? Colors.green : Colors.grey.shade600;
      case RecordingState.playing:
        return Colors.blue;
    }
  }

  String _getStatusText() {
    switch (_recordingState) {
      case RecordingState.idle:
        return 'Tap to record';
      case RecordingState.recording:
        return 'Recording...';
      case RecordingState.stopped:
        return widget.block.hasRecording ? 'Tap to play' : 'Tap to record';
      case RecordingState.playing:
        return 'Playing...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle (visible on hover)
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 8, top: 12),
                child: Icon(
                  Icons.drag_indicator,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            
            // Voice block content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mic,
                            size: 20,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voice Note',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Description input
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Describe your voice note requirements...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    
                    // Recording controls
                    _buildRecordingControls(),
                    
                    // Optional recording notes
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Additional notes (optional)...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Delete button (visible on hover)
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(left: 8, top: 8),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    final appProvider = context.read<AppProvider>();
                    appProvider.removeContentBlock(widget.block.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}