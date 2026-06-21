import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:fitflow/features/settings/domain/usecases/save_theme_mode.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_event.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeMode getThemeMode;
  final SaveThemeMode saveThemeMode;

  ThemeBloc({required this.getThemeMode, required this.saveThemeMode})
    : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    emit(ThemeLoading());
    final result = await getThemeMode(NoParams());
    result.fold((failure) => emit(ThemeError(message: failure.message)), (
      mode,
    ) {
      emit(ThemeLoaded(mode: mode));
    });
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final result = await saveThemeMode(event.mode);
    result.fold((failure) => emit(ThemeError(message: failure.message)), (_) {
      emit(ThemeLoaded(mode: event.mode));
    });
  }

}