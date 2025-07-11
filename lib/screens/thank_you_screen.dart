import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/progress_tracker.dart';
import '../widgets/mindlap_logo.dart';
import '../utils/ux_constants.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  final PageController _pageController = PageController();
  int _currentStoryIndex = 0;
  
  final List<SuccessStory> _successStories = [
    SuccessStory(
      quote: UXConstants.confirmationText['success_story']!,
      author: 'Sarah Chen',
      company: 'TechCorp',
      projectType: 'Voice Agent',
    ),
    SuccessStory(
      quote: '"The AI content generator saved us 15 hours a week. Game changer!"',
      author: 'Mike Rodriguez',
      company: 'CreativeStudio',
      projectType: 'Content Creation',
    ),
    SuccessStory(
      quote: '"Our conversion rate doubled with the new landing page. Amazing work!"',
      author: 'Lisa Park',
      company: 'StartupX',
      projectType: 'Landing Page',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Progress tracker
                  const ProgressTracker(currentStep: 2),
                  const SizedBox(height: 24),
                  
                  // MindLap branding
                  const MindLapLogo(size: 40),
                  const SizedBox(height: 32),
                  
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
                  const SizedBox(height: 16),
                  
                  // ETA badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF19211A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          UXConstants.confirmationText['eta']!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF19211A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    UXConstants.confirmationText['tracking']!,
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
                  
                  // Success Stories Carousel
                  _buildSuccessStoriesCarousel(),
                  
                  const SizedBox(height: 32),
                  
                  // Social sharing and referral
                  _buildSocialSection(),
                  
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
      ),
    );
  }

  Widget _buildSuccessStoriesCarousel() {
    return Column(
      children: [
        Text(
          'What Our Clients Say',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF19211A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentStoryIndex = index;
              });
            },
            itemCount: _successStories.length,
            itemBuilder: (context, index) {
              final story = _successStories[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF19211A).withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.quote,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        color: Color(0xFF19211A),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(0xFF19211A),
                                ),
                              ),
                              Text(
                                '${story.company} • ${story.projectType}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xFF19211A).withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_successStories.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: index == _currentStoryIndex
                    ? const Color(0xFF19211A)
                    : const Color(0xFF19211A).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.share_rounded,
            color: Color(0xFF19211A),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Love MindLap? Share with friends!',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF19211A),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Get 20% off your next project when they sign up',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF19211A).withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SocialButton(
                icon: Icons.link_rounded,
                label: 'Copy Link',
                onTap: () {
                  // Copy referral link logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral link copied!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _SocialButton(
                icon: Icons.email_rounded,
                label: 'Email',
                onTap: () {
                  // Email sharing logic
                },
              ),
              _SocialButton(
                icon: Icons.message_rounded,
                label: 'Message',
                onTap: () {
                  // SMS sharing logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF19211A),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF19211A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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

class SuccessStory {
  final String quote;
  final String author;
  final String company;
  final String projectType;

  SuccessStory({
    required this.quote,
    required this.author,
    required this.company,
    required this.projectType,
  });
}