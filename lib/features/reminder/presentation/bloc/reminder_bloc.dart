import 'package:fitflow/features/reminder/domain/usecases/load_reminder_settings_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/save_reminder_settings_usecase.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final LoadReminderSettingsUseCase loadSettings;
  final SaveReminderSettingsUseCase saveSettings;

  ReminderBloc({required this.loadSettings, required this.saveSettings})
    : super(ReminderInitial()) {
    on<ReminderLoadSettings>(_onLoad);
    on<ReminderToggleEnabled>(_onToggleEnabled);
    on<ReminderToggleDay>(_onToggleDay);
    on<ReminderUpdateTime>(_onUpdateTime);
    on<ReminderSaveSettings>(_onSave);
  }

  Future<void> _onLoad(
    ReminderLoadSettings event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      final result = await loadSettings();
      emit(
        ReminderLoaded(
          schedules: result.schedules,
          isEnabled: result.isEnabled,
        ),
      );
    } catch (e) {
      emit(ReminderError('Failed to load settings: $e'));
    }
  }

  void _onToggleEnabled(
    ReminderToggleEnabled event,
    Emitter<ReminderState> emit,
  ) {
    final current = state;
    if (current is! ReminderLoaded) return;
    emit(current.copyWith(isEnabled: event.isEnabled));
  }

  void _onToggleDay(ReminderToggleDay event, Emitter<ReminderState> emit) {
    final current = state;
    if (current is! ReminderLoaded) return;

    final updated = current.schedules.map((s) {
      if (s.dayOfWeek == event.dayOfWeek) {
        return s.copyWith(isEnabled: !s.isEnabled);
      }
      return s;
    }).toList();

    emit(current.copyWith(schedules: updated));
  }

  void _onUpdateTime(ReminderUpdateTime event, Emitter<ReminderState> emit) {
    final current = state;
    if (current is! ReminderLoaded) return;

    final updated = current.schedules.map((s) {
      if (s.dayOfWeek == event.dayOfWeek) {
        return s.copyWith(time: event.time);
      }
      return s;
    }).toList();

    emit(current.copyWith(schedules: updated));
  }

  Future<void> _onSave(
    ReminderSaveSettings event,
    Emitter<ReminderState> emit,
  ) async {
    final current = state;
    if (current is! ReminderLoaded) return;

    emit(current.copyWith(isSaving: true));

    try {
      await saveSettings(
        schedules: current.schedules,
        isEnabled: current.isEnabled,
      );
      emit(ReminderSaveSuccess(current.isEnabled));

      final result = await loadSettings();
      emit(
        ReminderLoaded(
          schedules: result.schedules,
          isEnabled: result.isEnabled,
        ),
      );
    } catch (e) {
      emit(ReminderError('Failed to save: $e'));
    }
  }
}
