import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const zero = ValueModel(raw: "0", numVal: 0, alt: "0", range: null);
  static const one = ValueModel(raw: "1", numVal: 1, alt: "1", range: null);
  static const empty =
      ValueModel(raw: "", numVal: null, alt: null, range: null);

  final String raw;
  final String? alt;
  final double? numVal;
  final NumRange? range;

  const ValueModel({
    required this.raw,
    required this.alt,
    this.numVal,
    this.range,
  });

  factory ValueModel.str(
    String value, {
    String? alt,
  }) {
    double? num = double.tryParse(value);

    if (num != null) {
      return ValueModel.numeric(num, alt: alt);
    }

    return ValueModel(
      raw: value,
      alt: alt ?? value,
      numVal: num,
      range: null,
    );
  }

  factory ValueModel.numeric(
    num value, {
    String? alt,
  }) {
    double? numVal = !value.isNaN ? value.toDouble() : null;

    String raw = DoubleValueUtils.format(numVal);

    return ValueModel(
      raw: raw,
      alt: alt ?? DoubleValueUtils.format(numVal, scientific: true),
      numVal: double.tryParse(raw),
      range: null,
    );
  }

  factory ValueModel.range(NumRange range) {
    return ValueModel(
      raw: range.rangeName,
      alt: range.rangeName,
      numVal: null,
      range: range,
    );
  }

  static ValueModel? any(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is ValueModel) {
      return value;
    }

    if (value is num) {
      return ValueModel.numeric(value);
    }

    if (value is String) {
      return value.isNotEmpty ? ValueModel.str(value) : null;
    }

    if (value is NumRange) {
      return ValueModel.range(value);
    }

    throw ConvertouchException(
      message: "Value $value has unsupported type",
      stackTrace: null,
      dateTime: DateTime.now(),
    );
  }

  ValueModel? betweenOrNull(ValueModel? min, ValueModel? max) {
    return NumRange.withBoth(
      min?.numVal,
      max?.numVal,
    ).includesNum(numVal)
        ? this
        : null;
  }

  ValueModel copyWith({
    String? raw,
    String? alt,
    double? numVal,
    NumRange? range,
  }) {
    return ValueModel(
      raw: raw ?? this.raw,
      alt: alt ?? this.alt,
      numVal: numVal ?? this.numVal,
      range: range ?? this.range,
    );
  }

  String get altOrRaw => alt ?? raw;

  bool get isNotEmpty => raw.isNotEmpty;

  bool get isEmpty => !isNotEmpty;

  @override
  List<Object?> get props => [
        raw,
        alt,
      ];

  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "raw": raw,
      "alt": alt,
      "num": numVal,
      "range": range?.toJson(removeNulls: removeNulls),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    String? raw = json["raw"];
    if (raw == null || raw == '') {
      return null;
    }

    return ValueModel(
      raw: raw,
      numVal: double.tryParse(json["num"]?.toString() ?? "") ??
          double.tryParse(raw),
      alt: json["alt"] ?? json["scientific"],
      range: NumRange.fromJson(json["range"]),
    );
  }

  @override
  String toString() {
    return 'ValueModel{'
        'raw: $raw, '
        'alt: $alt, '
        'num: $numVal, '
        'range: ${range?.rangeName}}';
  }
}
