import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required HiveService hiveService})
      : _hiveService = hiveService,
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeDisplayNameChanged>(_onDisplayNameChanged);
  }

  final HiveService _hiveService;

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final name = _hiveService.readDisplayName();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          displayName: name,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onDisplayNameChanged(
    HomeDisplayNameChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final trimmed = event.displayName.trim();
      if (trimmed.isEmpty) {
        await _hiveService.clearDisplayName();
        emit(
          state.copyWith(
            status: HomeStatus.success,
            displayName: null,
          ),
        );
        return;
      }
      await _hiveService.writeDisplayName(trimmed);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          displayName: trimmed,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
