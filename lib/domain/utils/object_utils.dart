import 'package:basic_utils/basic_utils.dart';
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

  static T coalesce<T>({
    required T what,
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

  static T? coalesceOrNull<T>({
    required T? v1,
    required T? v2,
    bool Function(T?)? isNotNullOrEmpty,
  }) {
    isNotNullOrEmpty ??= (value) => value != null;

    if (isNotNullOrEmpty.call(v1)) {
      return v1!;
    }
    if (isNotNullOrEmpty.call(v2)) {
      return v2!;
    }
    return null;
  }

  static String? coalesceStringOrNull({
    required String? str1,
    required String? str2,
  }) {
    return coalesceOrNull(
      v1: str1,
      v2: str2,
      isNotNullOrEmpty: (str) => StringUtils.isNotNullOrEmpty(str),
    );
  }

  static String coalesceStringOrDefault({
    required String? str1,
    required String? str2,
    String defaultStr = "",
  }) {
    return coalesceStringOrNull(str1: str1, str2: str2) ?? defaultStr;
  }
}
