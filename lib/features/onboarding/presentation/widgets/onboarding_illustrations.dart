import 'package:flutter/material.dart';

import '../../domain/onboarding_slide.dart';

abstract final class OnboardingAssets {
  static const uploadHero = 'assets/onboarding/onboarding_upload_hero.png';
  static const roast = 'assets/onboarding/onboarding_2.png';
  static const scoreCard = 'assets/onboarding/onboarding_score_card.png';
  static const levelUp = 'assets/onboarding/onboarding_level_up.png';
}

class OnboardingIllustrationView extends StatelessWidget {
  const OnboardingIllustrationView({
    required this.type,
    super.key,
  });

  final OnboardingIllustration type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      OnboardingIllustration.upload => const _UploadIllustration(),
      OnboardingIllustration.roast => const _RoastIllustration(),
      OnboardingIllustration.scoreCarousel => const _ScoreIllustration(),
      OnboardingIllustration.levelUp => const _LevelUpIllustration(),
    };
  }
}

class _UploadIllustration extends StatelessWidget {
  const _UploadIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.38;
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 56;

        return Image.asset(
          OnboardingAssets.uploadHero,
          fit: BoxFit.contain,
          width: maxWidth,
          height: maxHeight,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}

class _RoastIllustration extends StatelessWidget {
  const _RoastIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.38;
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 56;

        return Image.asset(
          OnboardingAssets.roast,
          fit: BoxFit.contain,
          width: maxWidth,
          height: maxHeight,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}

class _ScoreIllustration extends StatelessWidget {
  const _ScoreIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.38;
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 56;

        return Image.asset(
          OnboardingAssets.scoreCard,
          fit: BoxFit.contain,
          width: maxWidth,
          height: maxHeight,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}

class _LevelUpIllustration extends StatelessWidget {
  const _LevelUpIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.38;
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 56;

        return Image.asset(
          OnboardingAssets.levelUp,
          fit: BoxFit.contain,
          width: maxWidth,
          height: maxHeight,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}
