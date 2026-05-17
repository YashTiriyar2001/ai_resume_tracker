import 'package:custom_design_system/custom_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/cubit/app_cubit.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DsText(
          'AI Resume Tracker',
          type: TextType.Heading,
          size: TextSize.L,
          fontWeight: TextFontWeight.SemiBold,
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => _cycleTheme(context),
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.displayName != _nameController.text) {
            _nameController.text = state.displayName ?? '';
          }
        },
        builder: (context, state) {
          if (state.status == HomeStatus.loading &&
              state.displayName == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DsText(
                  'Welcome',
                  type: TextType.Heading,
                  size: TextSize.XL,
                  fontWeight: TextFontWeight.Bold,
                ),
                const SizedBox(height: 8),
                DsText(
                  state.displayName == null
                      ? 'Set a display name — stored locally with Hive.'
                      : 'Hello, ${state.displayName}!',
                  textColor: NeutralColor.color6,
                ),
                const SizedBox(height: 24),
                DsTextField(
                  controller: _nameController,
                  inputHintText: 'Display name',
                ),
                const SizedBox(height: 16),
                DsButton.primary(
                  'Save name',
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeDisplayNameChanged(_nameController.text),
                        );
                  },
                ),
                if (state.status == HomeStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  DsText(
                    state.errorMessage!,
                    textColor: ErrorColor.base,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _cycleTheme(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final current = cubit.state.themeMode;
    final next = switch (current) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    cubit.setThemeMode(next);
  }
}
