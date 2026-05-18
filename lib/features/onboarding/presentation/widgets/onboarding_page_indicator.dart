import 'package:flutter/material.dart';

import '../theme/onboarding_theme.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.count,
    required this.currentIndex,
    super.key,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? OnboardingTheme.dotActive(context) : null,
            border: isActive
                ? null
                : Border.all(
                    color: index == 0 && currentIndex > 0
                        ? OnboardingTheme.dotInactiveOutline(context)
                        : OnboardingTheme.dotInactive(context),
                    width: 1.5,
                  ),
          ),
        );
      }),
    );
  }
}
