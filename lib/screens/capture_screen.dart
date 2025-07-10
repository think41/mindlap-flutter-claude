import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/content_block.dart';
import '../widgets/text_block_widget.dart';
import '../widgets/image_block_widget.dart';
import '../widgets/voice_block_widget.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _submitRequirements() {
    final appProvider = context.read<AppProvider>();
    final requirements = appProvider.buildRequirementsFromBlocks();
    appProvider.updateRequirements(requirements);
    context.go('/thank-you');
  }

  void _showBlockTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Block',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _BlockTypeOption(
              icon: Icons.text_fields,
              title: 'Text',
              subtitle: 'Add text content',
              onTap: () {
                Navigator.pop(context);
                context.read<AppProvider>().addTextBlock();
              },
            ),
            _BlockTypeOption(
              icon: Icons.image,
              title: 'Image',
              subtitle: 'Upload an image',
              onTap: () {
                Navigator.pop(context);
                context.read<AppProvider>().addImageBlock();
              },
            ),
            _BlockTypeOption(
              icon: Icons.mic,
              title: 'Voice Note',
              subtitle: 'Add voice requirements',
              onTap: () {
                Navigator.pop(context);
                context.read<AppProvider>().addVoiceBlock();
              },
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final selectedArchetype = appProvider.selectedArchetype;

    if (selectedArchetype == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedArchetype.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Tell us about your project',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add blocks to describe your requirements',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Content blocks
                Expanded(
                  child: appProvider.contentBlocks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: appProvider.contentBlocks.length,
                          itemBuilder: (context, index) {
                            final block = appProvider.contentBlocks[index];
                            return _buildBlock(block);
                          },
                        ),
                ),
                
                // Add block button
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _showBlockTypeSelector,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Add a block',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Build button (only show when there are blocks)
          if (appProvider.contentBlocks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.extended(
                onPressed: _submitRequirements,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.build),
                label: const Text('Build'),
                heroTag: "build",
              ),
            ),
          // Add block button
          FloatingActionButton(
            onPressed: _showBlockTypeSelector,
            child: const Icon(Icons.add),
            heroTag: "add",
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Start by adding a block',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the + button to add text, images, or voice notes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BlockTypeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BlockTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}