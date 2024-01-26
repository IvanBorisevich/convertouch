import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class UseCase<InputType, OutputType> {
  const UseCase();

  Future<Either<ConvertouchException, OutputType>> execute(InputType input);
}

abstract class ReactiveUseCase<InputType, OutputType> {
  const ReactiveUseCase();

  Either<ConvertouchException, Stream<OutputType>> execute(InputType input);
}

abstract class UseCaseNoInput<OutputType> {
  const UseCaseNoInput();

  Future<Either<ConvertouchException, OutputType>> execute();
}