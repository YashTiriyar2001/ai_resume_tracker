import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/providers/bloc_providers.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/app/cubit/app_cubit.dart';
import '../features/app/cubit/app_state.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: BlocListener<AppCubit, AppState>(
        listenWhen: (previous, current) =>
            previous.onboardingComplete != current.onboardingComplete &&
            current.onboardingComplete,
        listener: (context, state) => _router.go('/'),
        child: BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode ||
              previous.status != current.status,
          builder: (context, state) {
            if (state.status != AppStatus.ready) {
              return const MaterialApp(
                home: SizedBox.shrink(),
              );
            }

            return MaterialApp.router(
              title: 'ATSify',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light().copyWith(
                textTheme: GoogleFonts.interTextTheme(AppTheme.light().textTheme),
              ),
              darkTheme: AppTheme.dark().copyWith(
                textTheme: GoogleFonts.interTextTheme(AppTheme.dark().textTheme),
              ),
              themeMode: state.themeMode,
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
