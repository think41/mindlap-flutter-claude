import 'package:flutter/foundation.dart';

enum BlockType {
  text,
  image,
  voice,
}

abstract class ContentBlock {
  final String id;
  final BlockType type;
  final int order;

  ContentBlock({
    required this.id,
    required this.type,
    required this.order,
  });

  ContentBlock copyWith({int? order});
  Map<String, dynamic> toJson();
}

class TextBlock extends ContentBlock {
  final String content;
  final String placeholder;

  TextBlock({
    required super.id,
    required super.order,
    this.content = '',
    this.placeholder = 'Type something...',
  }) : super(type: BlockType.text);

  @override
  TextBlock copyWith({int? order, String? content, String? placeholder}) {
    return TextBlock(
      id: id,
      order: order ?? this.order,
      content: content ?? this.content,
      placeholder: placeholder ?? this.placeholder,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'text',
      'order': order,
      'content': content,
      'placeholder': placeholder,
    };
  }
}

class ImageBlock extends ContentBlock {
  final String? fileName;
  final String? caption;
  final Uint8List? imageData;

  ImageBlock({
    required super.id,
    required super.order,
    this.fileName,
    this.caption,
    this.imageData,
  }) : super(type: BlockType.image);

  @override
  ImageBlock copyWith({
    int? order,
    String? fileName,
    String? caption,
    Uint8List? imageData,
  }) {
    return ImageBlock(
      id: id,
      order: order ?? this.order,
      fileName: fileName ?? this.fileName,
      caption: caption ?? this.caption,
      imageData: imageData ?? this.imageData,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'image',
      'order': order,
      'fileName': fileName,
      'caption': caption,
      'hasData': imageData != null,
    };
  }
}

class VoiceBlock extends ContentBlock {
  final String description;
  final String? recordingNotes;
  final String? audioPath;
  final Uint8List? audioData;
  final Duration? duration;

  VoiceBlock({
    required super.id,
    required super.order,
    this.description = '',
    this.recordingNotes,
    this.audioPath,
    this.audioData,
    this.duration,
  }) : super(type: BlockType.voice);

  @override
  VoiceBlock copyWith({
    int? order,
    String? description,
    String? recordingNotes,
    String? audioPath,
    Uint8List? audioData,
    Duration? duration,
  }) {
    return VoiceBlock(
      id: id,
      order: order ?? this.order,
      description: description ?? this.description,
      recordingNotes: recordingNotes ?? this.recordingNotes,
      audioPath: audioPath ?? this.audioPath,
      audioData: audioData ?? this.audioData,
      duration: duration ?? this.duration,
    );
  }

  bool get hasRecording => audioPath != null || audioData != null;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'voice',
      'order': order,
      'description': description,
      'recordingNotes': recordingNotes,
      'hasRecording': hasRecording,
      'duration': duration?.inSeconds,
    };
  }
}