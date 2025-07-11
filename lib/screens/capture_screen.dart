import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/content_block.dart';
import '../widgets/progress_tracker.dart';
import '../widgets/text_block_widget.dart';
import '../widgets/image_block_widget.dart';
import '../widgets/voice_block_widget.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF19211A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MindLap',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF19211A),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF19211A)),
              iconSize: 28,
              onPressed: () => context.go('/'),
            ),
          ),
          body: Stack(
            children: [
              _buildMainContent(appProvider),
              _buildFloatingActionBar(appProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(AppProvider appProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100), // Space for floating container
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  // Progress tracker
                  const ProgressTracker(currentStep: 1),
                  
                  // Header
                  _buildHeader(),
                  
                  // Content blocks
                  appProvider.contentBlocks.isEmpty
                      ? _buildEmptyState()
                      : _buildContentBlocks(appProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Describe your project',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFF19211A),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Share your ideas however you prefer',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF19211A).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlocks(AppProvider appProvider) {
    return Column(
      children: appProvider.contentBlocks.map((block) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildBlock(block),
        );
      }).toList(),
    );
  }

  Widget _buildFloatingActionBar(AppProvider appProvider) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                onPressed: _showBlockTypeSelector,
                backgroundColor: const Color(0xFF19211A),
                icon: Icons.add,
                heroTag: "add",
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                onPressed: () => _addBlock(appProvider.addVoiceBlock),
                backgroundColor: const Color(0xFFFF1E1E),
                icon: Icons.mic_rounded,
                heroTag: "voice",
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                onPressed: () => _addBlock(appProvider.addImageBlock),
                backgroundColor: const Color(0xFF19211A),
                icon: Icons.camera_alt_rounded,
                heroTag: "camera",
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                onPressed: appProvider.contentBlocks.isNotEmpty ? _submitRequirements : null,
                backgroundColor: appProvider.contentBlocks.isNotEmpty 
                    ? const Color(0xFF19211A) 
                    : const Color(0xFF19211A).withValues(alpha: 0.3),
                icon: Icons.rocket_launch_rounded,
                heroTag: "build",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required IconData icon,
    required String heroTag,
  }) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        heroTag: heroTag,
        child: Icon(icon),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF19211A).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 40,
              color: const Color(0xFF19211A).withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Share your ideas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF19211A),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Use the buttons below to add text, images, or voice notes to describe your project.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF19211A).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBlock(ContentBlock block) {
    switch (block.type) {
      case BlockType.text:
        return TextBlockWidget(block: block as TextBlock);
      case BlockType.image:
        return ImageBlockWidget(block: block as ImageBlock);
      case BlockType.voice:
        return VoiceBlockWidget(block: block as VoiceBlock);
    }
  }

  void _addBlock(VoidCallback addFunction) {
    addFunction();
    _showAutoSaveToast();
  }

  void _showBlockTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Add Content',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF19211A),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF19211A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.text_fields, color: Color(0xFF19211A)),
              ),
              title: const Text('Text'),
              subtitle: const Text('Add a text block'),
              onTap: () {
                Navigator.pop(context);
                _addBlock(context.read<AppProvider>().addTextBlock);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF19211A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Color(0xFF19211A)),
              ),
              title: const Text('Image'),
              subtitle: const Text('Upload an image'),
              onTap: () {
                Navigator.pop(context);
                _addBlock(context.read<AppProvider>().addImageBlock);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF1E1E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.mic, color: Color(0xFFFF1E1E)),
              ),
              title: const Text('Voice Note'),
              subtitle: const Text('Record your thoughts'),
              onTap: () {
                Navigator.pop(context);
                _addBlock(context.read<AppProvider>().addVoiceBlock);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAutoSaveToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Block added'),
          ],
        ),
        backgroundColor: const Color(0xFF19211A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitRequirements() {
    final appProvider = context.read<AppProvider>();
    final requirements = appProvider.buildRequirementsFromBlocks();
    appProvider.updateRequirements(requirements);
    context.go('/thank-you');
  }
}