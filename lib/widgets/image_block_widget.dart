import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/content_block.dart';
import '../providers/app_provider.dart';

class ImageBlockWidget extends StatefulWidget {
  final ImageBlock block;

  const ImageBlockWidget({
    super.key,
    required this.block,
  });

  @override
  State<ImageBlockWidget> createState() => _ImageBlockWidgetState();
}

class _ImageBlockWidgetState extends State<ImageBlockWidget> {
  late TextEditingController _captionController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.block.caption ?? '');
    
    _captionController.addListener(() {
      final appProvider = context.read<AppProvider>();
      final updatedBlock = widget.block.copyWith(caption: _captionController.text);
      appProvider.updateContentBlock(updatedBlock);
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    );

    if (result != null && result.files.isNotEmpty && mounted) {
      final file = result.files.first;
      final appProvider = context.read<AppProvider>();
      
      final updatedBlock = widget.block.copyWith(
        fileName: file.name,
        imageData: file.bytes,
      );
      
      appProvider.updateContentBlock(updatedBlock);
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
            
            // Image content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image display or upload area
                    if (widget.block.imageData != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.memory(
                          widget.block.imageData!,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      )
                    else
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: widget.block.caption?.isEmpty ?? true
                                ? BorderRadius.circular(8)
                                : const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Click to add image',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Caption input
                    if (widget.block.imageData != null || (widget.block.caption?.isNotEmpty ?? false))
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: widget.block.imageData != null
                              ? Border(top: BorderSide(color: Colors.grey.shade300))
                              : null,
                          borderRadius: widget.block.imageData != null
                              ? const BorderRadius.vertical(bottom: Radius.circular(8))
                              : null,
                        ),
                        child: TextField(
                          controller: _captionController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Add a caption...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
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