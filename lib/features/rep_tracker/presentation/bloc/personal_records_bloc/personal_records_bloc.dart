import 'package:app_lifecycle/core/usecases/usecase.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'personal_records_event.dart';
part 'personal_records_state.dart';

class PersonalRecordsBloc
    extends Bloc<PersonalRecordsEvent, PersonalRecordsState> {
  final GetPersonalRecords getPersonalRecords;
  PersonalRecordsBloc({required this.getPersonalRecords})
    : super(PersonalRecordsInitial()) {
    on<LoadPersonalRecords>(_onLoadPersonalRecords);
  }
  Future<void> _onLoadPersonalRecords(
    LoadPersonalRecords event,
    Emitter<PersonalRecordsState> emit,
  ) async {
    emit(const PersonalRecordLoading());
    final result = await getPersonalRecords(NoParams());
    result.fold(
      (failure) => emit(PersonalRecordLoadingError(message: failure.message)),
      (records) => emit(PersonalRecordsLoaded(records: records)),
    );
  }
}
