import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  String toString() => 'Failure(message: $message)';

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
