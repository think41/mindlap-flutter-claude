import 'package:flutter/material.dart';
import '../utils/ux_constants.dart';

class ProgressTracker extends StatelessWidget {
  final int currentStep;
  final bool showStepIndicator;

  const ProgressTracker({
    super.key,
    required this.currentStep,
    this.showStepIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showStepIndicator || currentStep < 0 || currentStep >= UXConstants.progressSteps.length) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          // Step indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = index <= currentStep;
              final isCurrent = index == currentStep;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive 
                      ? const Color(0xFF19211A)
                      : const Color(0xFF19211A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Step text
          Text(
            UXConstants.progressSteps[currentStep],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF19211A).withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}