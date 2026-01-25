import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class UseCase<I, O> {
  const UseCase();

  Future<Either<ConvertouchException, O>> execute(I input);
}

abstract class UseCaseGenericInput<I, O> {
  const UseCaseGenericInput();

  Future<Either<ConvertouchException, O>> execute<T>(I input);
}

abstract class UseCaseNoInput<O> {
  const UseCaseNoInput();

  Future<Either<ConvertouchException, O>> execute();
}

abstract class ReactiveUseCase<I, O> {
  const ReactiveUseCase();

  Either<ConvertouchException, Stream<O>> execute(I input);
}
