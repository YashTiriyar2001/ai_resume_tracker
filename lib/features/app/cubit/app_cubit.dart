import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/preferences_service.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required PreferencesService preferences})
      : _preferences = preferences,
        super(const AppState());

  final PreferencesService _preferences;

  Future<void> load() async {
    final stored = _preferences.getString(StorageKeys.themeMode);
    final themeMode = _parseThemeMode(stored);
    final onboardingComplete =
        _preferences.getBool(StorageKeys.onboardingComplete) ?? false;
    emit(
      state.copyWith(
        themeMode: themeMode,
        status: AppStatus.ready,
        onboardingComplete: onboardingComplete,
      ),
    );
  }

  Future<void> completeOnboarding() async {
    emit(state.copyWith(onboardingComplete: true));
    await _preferences.setBool(StorageKeys.onboardingComplete, true);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _preferences.setString(StorageKeys.themeMode, mode.name);
  }

  ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }
}
