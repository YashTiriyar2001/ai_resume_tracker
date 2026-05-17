import 'package:equatable/equatable.dart';

import '../../domain/roast_record.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.displayName,
    this.roasts = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final String? displayName;
  final List<RoastRecord> roasts;
  final String? errorMessage;

  int get totalRoasts => roasts.length;

  int? get averageScore => roasts.isEmpty ? null : RoastStats.averageScore(roasts);

  int get streakDays => RoastStats.streakDays(roasts);

  int? get fastestAnalysisMs => RoastStats.fastestAnalysisMs(roasts);

  List<RoastRecord> get recentRoasts => roasts.take(10).toList();

  List<RoastRecord> get savedRoasts =>
      roasts.where((roast) => roast.isSaved).toList();

  String get greetingName {
    final name = displayName?.trim();
    if (name == null || name.isEmpty) return 'there';
    return name;
  }

  String get fastestAnalysisLabel {
    final ms = fastestAnalysisMs;
    if (ms == null) return '—';
    if (ms < 1000) return '${ms}ms';
    return '${(ms / 1000).toStringAsFixed(1)}s';
  }

  HomeState copyWith({
    HomeStatus? status,
    String? displayName,
    List<RoastRecord>? roasts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      roasts: roasts ?? this.roasts,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, displayName, roasts, errorMessage];
}
