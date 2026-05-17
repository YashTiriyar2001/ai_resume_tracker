import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/analysis/domain/analysis_request.dart';
import '../../features/analysis/presentation/pages/loading_page.dart';
import '../../features/analysis/presentation/pages/result_page.dart';
import '../../features/app/cubit/app_cubit.dart';
import '../../features/app/cubit/app_state.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

abstract final class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        final appState = context.read<AppCubit>().state;
        if (appState.status != AppStatus.ready) return null;

        final location = state.matchedLocation;
        final onOnboarding = location == '/onboarding';

        if (!appState.onboardingComplete && !onOnboarding) {
          return '/onboarding';
        }
        if (appState.onboardingComplete && onOnboarding) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'analyze',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final request = state.extra! as AnalysisRequest;
                return LoadingPage(request: request);
              },
            ),
            GoRoute(
              path: 'result/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                return ResultPage(roastId: state.pathParameters['id']!);
              },
            ),
          ],
        ),
      ],
    );
  }
}
