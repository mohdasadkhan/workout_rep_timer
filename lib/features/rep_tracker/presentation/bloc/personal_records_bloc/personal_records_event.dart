part of 'personal_records_bloc.dart';

sealed class PersonalRecordsEvent extends Equatable {
  const PersonalRecordsEvent();

  @override
  List<Object> get props => [];
}

class LoadPersonalRecords extends PersonalRecordsEvent {
  const LoadPersonalRecords();
}
