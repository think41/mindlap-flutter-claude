import 'package:flutter/material.dart';

class MindLapLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const MindLapLogo({
    super.key,
    this.size = 32,
    this.showText = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? const Color(0xFF19211A);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon with F1 red accent
        Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: logoColor,
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Icon(
                Icons.psychology_rounded,
                size: size * 0.6,
                color: Colors.white,
              ),
            ),
            // F1 red accent dot
            Positioned(
              top: size * 0.15,
              right: size * 0.15,
              child: Container(
                width: size * 0.2,
                height: size * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF1E1E), // F1 red
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'MindLap',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: size * 0.5,
              fontWeight: FontWeight.w700,
              color: logoColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}