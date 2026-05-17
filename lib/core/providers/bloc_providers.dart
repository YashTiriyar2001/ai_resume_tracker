import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app/cubit/app_cubit.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../di/injection.dart';

/// Central registry for all [BlocProvider]s used by the app.
class BlocProviders extends StatelessWidget {
  const BlocProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (_) => getIt<AppCubit>()..load(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
        ),
      ],
      child: child,
    );
  }
}
