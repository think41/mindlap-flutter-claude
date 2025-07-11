import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_block.dart';
import '../providers/app_provider.dart';
import '../utils/ux_constants.dart';

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
  bool _isFocused = false;

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
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
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
              child: Column(
                children: [
                  TextField(
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
                  // Character/word count hints
                  if (_isFocused || _controller.text.isNotEmpty)
                    _buildCountHints(),
                ],
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

  Widget _buildCountHints() {
    final text = _controller.text;
    final wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final charCount = text.length;
    
    // Determine status based on word count
    String statusText;
    Color statusColor;
    
    if (wordCount == 0) {
      statusText = UXConstants.tooltips['text_target']!;
      statusColor = Colors.grey.shade500;
    } else if (wordCount < 10) {
      statusText = 'Keep going! More details help create better results';
      statusColor = Colors.orange;
    } else if (wordCount <= 200) {
      statusText = 'Perfect length for clear requirements';
      statusColor = Colors.green;
    } else {
      statusText = 'Consider breaking into smaller sections';
      statusColor = Colors.orange;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$wordCount words • $charCount chars',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}