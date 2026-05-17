import 'package:flutter/material.dart';

import '../../domain/onboarding_slide.dart';
import '../theme/onboarding_theme.dart';
import 'onboarding_illustrations.dart';

class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({
    required this.slide,
    super.key,
  });

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          if (slide.header != null) ...[
            const SizedBox(height: 8),
            Text(
              slide.header!,
              style: OnboardingTheme.headerStyle,
              textAlign: TextAlign.center,
            ),
          ],
          Expanded(
            flex: 4,
            child: Center(
              child: OnboardingIllustrationView(type: slide.illustration),
            ),
          ),
          Text(
            slide.title,
            style: OnboardingTheme.titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            slide.subtitle,
            style: OnboardingTheme.subtitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
