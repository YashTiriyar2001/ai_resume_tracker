import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  const AppState({
    this.themeMode = ThemeMode.system,
    this.status = AppStatus.initial,
  });

  final ThemeMode themeMode;
  final AppStatus status;

  AppState copyWith({
    ThemeMode? themeMode,
    AppStatus? status,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [themeMode, status];
}

enum AppStatus { initial, ready }
