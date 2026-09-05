import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/ai_coach/domain/usecases/build_fitness_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coach_home_event.dart';
import 'coach_home_state.dart';

class CoachHomeBloc extends Bloc<CoachHomeEvent, CoachHomeState> {
  final BuildFitnessContext _buildFitnessContext;

  CoachHomeBloc({required BuildFitnessContext buildFitnessContext})
    : _buildFitnessContext = buildFitnessContext,
      super(const CoachHomeInitial()) {
    on<CoachHomeLoadRequested>(_onLoad);
    on<CoachHomeRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    CoachHomeLoadRequested event,
    Emitter<CoachHomeState> emit,
  ) async {
    emit(const CoachHomeLoading());
    await _loadContext(emit);
  }

  Future<void> _onRefresh(
    CoachHomeRefreshRequested event,
    Emitter<CoachHomeState> emit,
  ) async {
    final current = state;
    if (current is! CoachHomeLoaded) {
      emit(const CoachHomeLoading());
    }
    await _loadContext(emit);
  }

  Future<void> _loadContext(Emitter<CoachHomeState> emit) async {
    final result = await _buildFitnessContext(NoParams());

    result.fold(
      (failure) => emit(CoachHomeError(message: failure.message)),
      (context) => emit(CoachHomeLoaded(context: context)),
    );
  }
}
