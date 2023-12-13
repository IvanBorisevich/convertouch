import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

abstract class UseCase<InputType, OutputType> {
  const UseCase();

  Future<Either<Failure, OutputType>> execute(InputType input);
}

abstract class UseCaseNoInput<OutputType> {
  const UseCaseNoInput();

  Future<Either<Failure, OutputType>> execute();
}