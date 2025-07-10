import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFA),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF19211A),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Thank You!',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: const Color(0xFF19211A),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your requirements have been captured successfully.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF19211A).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We will get back to you soon with your project details.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF19211A).withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Summary Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF19211A).withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        color: const Color(0xFF19211A).withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Summary',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color(0xFF19211A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SummaryRow(
                          label: 'Project Type',
                          value: appProvider.selectedArchetype?.title ?? 'Not selected',
                        ),
                        if (appProvider.requirements.textDescription?.isNotEmpty == true)
                          _SummaryRow(
                            label: 'Description',
                            value: appProvider.requirements.textDescription!,
                          ),
                        if (appProvider.requirements.imageNames.isNotEmpty)
                          _SummaryRow(
                            label: 'Images',
                            value: '${appProvider.requirements.imageNames.length} file(s)',
                          ),
                        if (appProvider.requirements.voiceNoteDescription?.isNotEmpty == true)
                          _SummaryRow(
                            label: 'Voice Notes',
                            value: appProvider.requirements.voiceNoteDescription!,
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Start Over Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      appProvider.reset();
                      context.go('/');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start New Project',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}