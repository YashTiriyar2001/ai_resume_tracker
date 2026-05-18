import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Reload roasts from storage (e.g. after a new analysis completes).
final class HomeRoastsRefreshed extends HomeEvent {
  const HomeRoastsRefreshed();
}

final class HomeDisplayNameChanged extends HomeEvent {
  const HomeDisplayNameChanged(this.displayName);

  final String displayName;

  @override
  List<Object?> get props => [displayName];
}
