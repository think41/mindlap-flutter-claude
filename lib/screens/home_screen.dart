import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/archetype.dart';
import '../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFA), // Subtle off-white background
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MindLap branding
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF19211A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'MindLap',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Choose Your Project Type',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: const Color(0xFF19211A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Select the type of project you want to build with AI',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF19211A).withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ...Archetype.values.map((archetype) => 
                  _ArchetypeCard(
                    archetype: archetype,
                    onTap: () {
                      appProvider.selectArchetype(archetype);
                      context.go('/capture');
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Powered by AI • Built for Innovation',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF19211A).withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchetypeCard extends StatefulWidget {
  final Archetype archetype;
  final VoidCallback onTap;

  const _ArchetypeCard({
    required this.archetype,
    required this.onTap,
  });

  @override
  State<_ArchetypeCard> createState() => _ArchetypeCardState();
}

class _ArchetypeCardState extends State<_ArchetypeCard> {
  bool _isHovered = false;

  IconData _getArchetypeIcon(Archetype archetype) {
    switch (archetype) {
      case Archetype.voiceAgent:
        return Icons.mic_rounded;
      case Archetype.contentCreation:
        return Icons.edit_rounded;
      case Archetype.landingPage:
        return Icons.web_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered 
                ? const Color(0xFF19211A)
                : const Color(0xFF19211A).withOpacity(0.1),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: _isHovered ? 12 : 6,
                color: const Color(0xFF19211A).withOpacity(_isHovered ? 0.15 : 0.08),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF), // Alice blue background
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getArchetypeIcon(widget.archetype),
                            size: 24,
                            color: const Color(0xFF19211A),
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: _isHovered ? 0.125 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: const Color(0xFF19211A).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.archetype.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF19211A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.archetype.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF19211A).withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}