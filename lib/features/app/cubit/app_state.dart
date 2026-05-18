import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  const AppState({
    this.themeMode = ThemeMode.dark,
    this.status = AppStatus.initial,
    this.onboardingComplete = false,
  });

  final ThemeMode themeMode;
  final AppStatus status;
  final bool onboardingComplete;

  AppState copyWith({
    ThemeMode? themeMode,
    AppStatus? status,
    bool? onboardingComplete,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      status: status ?? this.status,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  List<Object?> get props => [themeMode, status, onboardingComplete];
}

enum AppStatus { initial, ready }
