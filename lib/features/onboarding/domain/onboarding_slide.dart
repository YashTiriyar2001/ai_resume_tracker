enum OnboardingIllustration {
  upload,
  roast,
  scoreCarousel,
  levelUp,
}

class OnboardingSlide {
  const OnboardingSlide({
    this.header,
    required this.title,
    required this.subtitle,
    required this.illustration,
    this.showSkip = false,
    this.buttonLabel = 'Next',
  });

  final String? header;
  final String title;
  final String subtitle;
  final OnboardingIllustration illustration;
  final bool showSkip;
  final String buttonLabel;
}

const onboardingSlides = <OnboardingSlide>[
  OnboardingSlide(
    header: 'Welcome to ATSify 🔥',
    title: 'Tired of your resume getting ghosted?',
    subtitle:
        'Upload any resume (PDF, DOCX, TXT, or photo). No boring templates allowed.',
    illustration: OnboardingIllustration.upload,
  ),
  OnboardingSlide(
    title: 'We read it like an ATS... then we roast it',
    subtitle:
        'No sugarcoating. Just savage, honest feedback that actually helps you get hired.',
    illustration: OnboardingIllustration.roast,
  ),
  OnboardingSlide(
    header: 'Popping',
    title: 'Get a brutally honest score + fix list',
    subtitle:
        'See exactly why recruiters are ghosting you and how to fix it in seconds.',
    illustration: OnboardingIllustration.scoreCarousel,
  ),
  OnboardingSlide(
    title: 'Laugh while you level up your career',
    subtitle:
        'Thousands have already gotten roasted... and hired. Your turn?',
    illustration: OnboardingIllustration.levelUp,
    showSkip: true,
    buttonLabel: "LET'S ATSIFY MY RESUME 🔥",
  ),
];
