import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:either_dart/either.dart';

class ObjectUtils {
  const ObjectUtils._();

  static R tryGet<R>(Either<ConvertouchException, R> either) {
    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
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

  static T? patch<T>(T? what, Patchable<T>? patch) {
    return patch != null && patch.value == null && patch.forcePatchNull
        ? null
        : (patch?.value ?? what);
  }

  static ItemSearchMatch toSearchMatch(String source, String searchString) {
    RegExp pattern = RegExp(searchString, caseSensitive: false);
    int matchIndex = source.indexOf(pattern);

    if (matchIndex == -1) {
      return ItemSearchMatch.none;
    }

    List<String> lexemes = [];
    lexemes.add(source.substring(0, matchIndex));
    lexemes.add(source.substring(matchIndex, matchIndex + searchString.length));
    lexemes.add(source.substring(matchIndex + searchString.length));

    lexemes = lexemes.where((lexeme) => lexeme.isNotEmpty).toList();
    int matchedLexemeIndex =
        lexemes.indexWhere((lexeme) => pattern.hasMatch(lexeme));

    return ItemSearchMatch(
      lexemes: lexemes,
      matchedLexemeIndex: matchedLexemeIndex,
    );
  }
}

class Patchable<T> {
  final T? value;
  final bool forcePatchNull;

  const Patchable(
    this.value, {
    this.forcePatchNull = false,
  });
}
