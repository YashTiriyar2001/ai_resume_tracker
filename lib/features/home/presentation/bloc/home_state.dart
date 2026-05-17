import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.displayName,
    this.errorMessage,
  });

  final HomeStatus status;
  final String? displayName;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    String? displayName,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, displayName, errorMessage];
}
