import 'package:convertouch/domain/entities/failure_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<InputType, OutputType> {
  const UseCase();

  Future<Either<OutputType, FailureEntity>> execute({InputType input});
}