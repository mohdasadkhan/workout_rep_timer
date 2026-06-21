import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';

abstract class ClearDataRepository {
  Future<Either<Failure, Unit>> clearAllData();
}