import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Every use case follows this contract — I in SOLID (Interface Segregation)
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Used when a use case needs no input parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
