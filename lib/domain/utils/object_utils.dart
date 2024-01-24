import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

class ObjectUtils {
  const ObjectUtils._();

  static R tryGet<R>(Either<Failure, R> either) {
    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }

  static T? coalesce<T>({
    required T? what,
    required T? patchWith,
    required bool replaceWithNull,
  }) {
    if (replaceWithNull) {
      return patchWith;
    } else {
      return patchWith ?? what;
    }
  }
}