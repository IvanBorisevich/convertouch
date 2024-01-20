import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

class EitherUtils {
  const EitherUtils._();

  static R tryGet<R>(Either<Failure, R> either) {
    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}