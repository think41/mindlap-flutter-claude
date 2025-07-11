class UXConstants {
  // Brand colors
  static const String brandGreen = '#19211A';
  static const String brandBlue = '#F0F8FF';
  static const String brandRed = '#FF1E1E'; // F1 red for highlights
  
  // Progress indicators
  static const List<String> progressSteps = [
    'Step 1 of 3 – Choose your project type',
    'Step 2 of 3 – Describe your project',
    'Step 3 of 3 – Review and submit'
  ];

  // Ghost text for empty states - Multiple viable options
  static const Map<String, String> ghostText = {
    'voice': '🎤 Describe your project with your voice\n\nJust speak naturally! Tell us what you want to build, who it\'s for, and any specific features you have in mind.',
    'text': 'Type your requirements here\n\nFor example: "I need a voice assistant that can help users book appointments, answer FAQs about our services, and integrate with our existing calendar system."',
    'image': 'Add visual inspiration, mockups, or examples\n\nDrag and drop images here or click to upload'
  };

  // Trust and privacy microcopy
  static const Map<String, String> privacyText = {
    'voice': '🔒 Audio is transcribed securely and auto-deleted after processing',
    'image': '🔒 Images stay private to your project and are not shared',
    'general': '🔒 All your data is encrypted and kept confidential'
  };

  // Benefit text for archetype cards
  static const Map<String, String> archetypeBenefits = {
    'voice_agent': 'Get 24/7 customer support automation',
    'content_creation': 'Generate content 10x faster with AI',
    'landing_page': 'Convert visitors into customers'
  };

  // Encouragement prompts
  static const List<String> enrichmentPrompts = [
    'Add an image or voice note for more context?',
    'Consider adding a visual example to clarify your vision',
    'A voice note could help us understand your tone preferences',
    'Adding more details helps us create exactly what you need'
  ];

  // Success microcopy
  static const Map<String, String> confirmationText = {
    'eta': 'Prototype ready in ~15 minutes',
    'tracking': 'We\'ll send updates to your email',
    'success_story': '"MindLap helped us launch our AI assistant in just 2 weeks!" - Sarah, TechCorp'
  };

  // Tooltip guidance
  static const Map<String, String> tooltips = {
    'add_button': 'Click here to add text, images, or voice notes',
    'voice_button': 'Record your requirements by voice',
    'image_drop': 'Drag images directly here',
    'text_target': 'Aim for 50-200 words for best results'
  };

  // Auto-save messages
  static const List<String> autoSaveMessages = [
    'Draft saved ✓',
    'Progress saved automatically ✓',
    'Your work is safe ✓'
  ];
}