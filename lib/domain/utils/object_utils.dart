import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

class ObjectUtils {
  const ObjectUtils._();

  static R tryGet<R>(Either<ConvertouchException, R> either) {
    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }

  static T? coalesce<T>({
    required T? what,
    required T? patchWith,
  }) {
    return patchWith ?? what;
  }

  static Map<String, T> convertToMap<T>(
    Map<String, dynamic>? map, {
    T Function(dynamic)? valueMapFunc,
  }) {
    if (map == null) {
      return {};
    }

    return map.map(
      (key, value) => MapEntry(
        key,
        valueMapFunc != null
            ? valueMapFunc.call(value)
            : value?.toString() as T,
      ),
    );
  }
}
