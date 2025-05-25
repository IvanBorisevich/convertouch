import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:either_dart/either.dart';

const _alphaCodes = NumRange(65, 90);

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

  static bool isNotNullOrEmpty(String? str) {
    return str != null && str.isNotEmpty && str.toLowerCase() != "null";
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

  static List<String> generateNumList(
    double min,
    double max, {
    double step = 1,
    double? divisor,
    int? fractionDigits,
  }) {
    int length = ((max - min) / step + 1).floor();
    String Function(int) func;

    if (divisor != null) {
      func = (index) => DoubleValueUtils.numToStr(
            (min + index * step) / divisor,
            fractionDigits: fractionDigits,
          );
    } else {
      func = (index) => DoubleValueUtils.numToStr(
            min + index * step,
            fractionDigits: fractionDigits,
          );
    }
    return List.generate(length, func);
  }

  static List<String> fromNumList(
    List<num> l, {
    double? divisor,
    int? fractionDigits,
  }) {
    String Function(num) func;

    if (divisor != null) {
      func = (v) => DoubleValueUtils.numToStr(
            v / divisor,
            fractionDigits: fractionDigits,
          );
    } else {
      func = (v) => DoubleValueUtils.numToStr(
            v,
            fractionDigits: fractionDigits,
          );
    }

    return l.map(func).toList();
  }

  static List<String> generateAlphaList(
    String from,
    String to,
  ) {
    int startCode = from.codeUnitAt(0);
    int endCode = to.codeUnitAt(0);

    if (!_alphaCodes.contains(startCode) || !_alphaCodes.contains(endCode)) {
      return [];
    }

    int listSize = endCode - startCode + 1;

    if (listSize <= 0) {
      return [];
    }

    int offset = startCode - _alphaCodes.left.toInt();

    return List.generate(
      listSize,
      (index) => String.fromCharCode(index + _alphaCodes.left.toInt() + offset),
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
