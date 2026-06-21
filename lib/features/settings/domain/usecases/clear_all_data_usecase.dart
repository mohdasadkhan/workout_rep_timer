import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/settings/domain/repositories/clear_data_repository.dart';

class ClearAllDataUseCase implements UseCase<Unit, NoParams> {
  final ClearDataRepository repository;

  ClearAllDataUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return repository.clearAllData();
  }
}