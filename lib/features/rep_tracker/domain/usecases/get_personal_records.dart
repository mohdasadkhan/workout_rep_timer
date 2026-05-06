import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/personal_record.dart';
import '../repositories/workout_repository.dart';

class GetPersonalRecords implements UseCase<List<PersonalRecord>, NoParams> {
  final WorkoutRepository repository;

  const GetPersonalRecords(this.repository);

  @override
  Future<Either<Failure, List<PersonalRecord>>> call(NoParams params) async {
    return repository.getPersonalRecords();
  }
}