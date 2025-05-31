import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const zero = ValueModel._(raw: "0", numVal: 0, alt: "0");
  static const one = ValueModel._(raw: "1", numVal: 1, alt: "1");
  static const undef = ValueModel._(raw: '-', numVal: null, alt: "");

  final String raw;
  final String alt;
  final double? numVal;

  const ValueModel._({
    required this.raw,
    required this.alt,
    required this.numVal,
  });

  factory ValueModel.str(String value) {
    double? num = double.tryParse(value);

    if (num != null) {
      return ValueModel.numeric(num);
    }

    return ValueModel._(
      raw: value,
      alt: value,
      numVal: num,
    );
  }

  factory ValueModel.numeric(num value) {
    double? numVal = !value.isNaN ? value.toDouble() : null;

    String raw = DoubleValueUtils.format(numVal);

    return ValueModel._(
      raw: raw,
      alt: DoubleValueUtils.format(numVal, scientific: true),
      numVal: double.tryParse(raw),
    );
  }

  static ValueModel? any(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return ValueModel.numeric(value);
    }

    if (value is String) {
      return value.isNotEmpty ? ValueModel.str(value) : null;
    }

    throw ConvertouchException(
      message: "Value $value has unsupported type",
      stackTrace: null,
      dateTime: DateTime.now(),
    );
  }

  ValueModel? betweenOrNull(ValueModel? min, ValueModel? max) {
    return DoubleValueUtils.between(
      value: numVal,
      min: min?.numVal,
      max: max?.numVal,
    )
        ? this
        : null;
  }

  @override
  List<Object?> get props => [
        raw,
        alt,
      ];

  Map<String, dynamic> toJson() {
    return {
      "raw": raw,
      "alt": alt,
      "num": numVal,
    };
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    String? raw = json["raw"];
    if (raw == null || raw == '') {
      return null;
    }

    return ValueModel._(
      raw: raw,
      numVal: double.tryParse(json["num"]?.toString() ?? "") ??
          double.tryParse(raw),
      alt: json["alt"] ?? json["scientific"],
    );
  }

  @override
  String toString() {
    return 'ValueModel{raw: $raw, alt: $alt, num: $numVal}';
  }
}
