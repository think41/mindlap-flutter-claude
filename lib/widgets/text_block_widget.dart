import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_block.dart';
import '../providers/app_provider.dart';

class TextBlockWidget extends StatefulWidget {
  final TextBlock block;

  const TextBlockWidget({
    super.key,
    required this.block,
  });

  @override
  State<TextBlockWidget> createState() => _TextBlockWidgetState();
}

class _TextBlockWidgetState extends State<TextBlockWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
    _focusNode = FocusNode();
    
    _controller.addListener(() {
      final appProvider = context.read<AppProvider>();
      final updatedBlock = widget.block.copyWith(content: _controller.text);
      appProvider.updateContentBlock(updatedBlock);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
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
            
            // Text input field
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: InputDecoration(
                  hintText: widget.block.placeholder,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onTap: () {
                  _focusNode.requestFocus();
                },
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