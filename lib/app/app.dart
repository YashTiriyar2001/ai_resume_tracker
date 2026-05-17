import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/providers/bloc_providers.dart';
import '../core/theme/app_theme.dart';
import '../features/app/cubit/app_cubit.dart';
import '../features/app/cubit/app_state.dart';
import '../features/home/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.status != current.status,
        builder: (context, state) {
          return MaterialApp(
            title: 'AI Resume Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
