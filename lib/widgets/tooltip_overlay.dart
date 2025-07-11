import 'package:flutter/material.dart';
import '../utils/ux_constants.dart';

class TooltipOverlay extends StatefulWidget {
  final Widget child;
  final bool showTooltips;
  final VoidCallback onTooltipDismissed;

  const TooltipOverlay({
    super.key,
    required this.child,
    required this.showTooltips,
    required this.onTooltipDismissed,
  });

  @override
  State<TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<TooltipOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentTooltipIndex = 0;
  
  final List<TooltipInfo> _tooltips = [
    TooltipInfo(
      text: UXConstants.tooltips['add_button']!,
      targetKey: 'add_button',
      position: TooltipPosition.top,
    ),
    TooltipInfo(
      text: UXConstants.tooltips['voice_button']!,
      targetKey: 'voice_button',
      position: TooltipPosition.top,
    ),
    TooltipInfo(
      text: UXConstants.tooltips['text_target']!,
      targetKey: 'text_area',
      position: TooltipPosition.bottom,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.showTooltips) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextTooltip() {
    if (_currentTooltipIndex < _tooltips.length - 1) {
      setState(() {
        _currentTooltipIndex++;
      });
    } else {
      _dismissTooltips();
    }
  }

  void _dismissTooltips() {
    _animationController.reverse().then((_) {
      widget.onTooltipDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showTooltips)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Stack(
                    children: [
                      // Backdrop
                      GestureDetector(
                        onTap: _dismissTooltips,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                        ),
                      ),
                      // Current tooltip
                      if (_currentTooltipIndex < _tooltips.length)
                        _buildTooltip(_tooltips[_currentTooltipIndex]),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTooltip(TooltipInfo tooltip) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.3,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF19211A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tip ${_currentTooltipIndex + 1} of ${_tooltips.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF19211A),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _dismissTooltips,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF19211A),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tooltip.text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF19211A),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progress dots
                Row(
                  children: List.generate(_tooltips.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: index <= _currentTooltipIndex
                            ? const Color(0xFF19211A)
                            : const Color(0xFF19211A).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                // Next button
                ElevatedButton(
                  onPressed: _nextTooltip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19211A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    _currentTooltipIndex < _tooltips.length - 1 ? 'Next' : 'Got it',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TooltipInfo {
  final String text;
  final String targetKey;
  final TooltipPosition position;

  TooltipInfo({
    required this.text,
    required this.targetKey,
    required this.position,
  });
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
}