enum Archetype {
  voiceAgent('Voice Agent', 'Build AI-powered voice assistants'),
  contentCreation('Content Creation App', 'Create tools for content generation'),
  landingPage('Landing Page', 'Design beautiful landing pages');

  const Archetype(this.title, this.description);
  final String title;
  final String description;
}