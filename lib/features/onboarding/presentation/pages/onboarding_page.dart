import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../app/cubit/app_cubit.dart';
import '../../domain/onboarding_slide.dart';
import '../widgets/ember_background.dart';
import '../widgets/onboarding_gradient_button.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_slide_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _applySystemUi(AppPalette colors) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: colors.isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            colors.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: colors.background,
        systemNavigationBarIconBrightness:
            colors.isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void _onNext() {
    if (_currentPage < onboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    context.read<AppCubit>().completeOnboarding();
  }

  void _onSkip() {
    context.read<AppCubit>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    _applySystemUi(colors);

    final slide = onboardingSlides[_currentPage];
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const EmberBackground(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: slide.showSkip
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextButton(
                              onPressed: _onSkip,
                              style: TextButton.styleFrom(
                                backgroundColor: colors.surfaceElevated,
                                foregroundColor: colors.headline,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingSlides.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return OnboardingSlideView(slide: onboardingSlides[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28, 0, 28, 12 + bottomPadding),
                  child: Column(
                    children: [
                      OnboardingGradientButton(
                        label: slide.buttonLabel,
                        onPressed: _onNext,
                      ),
                      const SizedBox(height: 20),
                      OnboardingPageIndicator(
                        count: onboardingSlides.length,
                        currentIndex: _currentPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
