part of 'personal_records_bloc.dart';

sealed class PersonalRecordsState extends Equatable {
  const PersonalRecordsState();

  @override
  List<Object?> get props => [];
}

final class PersonalRecordsInitial extends PersonalRecordsState {}

class PersonalRecordsLoaded extends PersonalRecordsState {
  final List<PersonalRecord> records;
  const PersonalRecordsLoaded({required this.records});

  @override
  List<Object?> get props => [records];
}

class PersonalRecordLoading extends PersonalRecordsState {
  const PersonalRecordLoading();
}

class PersonalRecordLoadingError extends PersonalRecordsState {
  final String message;
  const PersonalRecordLoadingError({required this.message});

  @override
  List<Object?> get props => [message];
}
