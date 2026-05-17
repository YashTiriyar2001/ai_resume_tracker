import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import '../../data/roast_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required HiveService hiveService,
    required RoastRepository roastRepository,
  })  : _hiveService = hiveService,
        _roastRepository = roastRepository,
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeDisplayNameChanged>(_onDisplayNameChanged);
  }

  final HiveService _hiveService;
  final RoastRepository _roastRepository;

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, clearErrorMessage: true));
    try {
      final roasts = await _roastRepository.fetchRoasts();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          displayName: _hiveService.readDisplayName(),
          roasts: roasts,
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
    emit(state.copyWith(status: HomeStatus.loading, clearErrorMessage: true));
    try {
      final trimmed = event.displayName.trim();
      if (trimmed.isEmpty) {
        await _hiveService.clearDisplayName();
      } else {
        await _hiveService.writeDisplayName(trimmed);
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          displayName: trimmed.isEmpty ? null : trimmed,
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
