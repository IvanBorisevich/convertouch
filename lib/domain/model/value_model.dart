import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const emptyString = ValueModel._(raw: "", numVal: null, alt: "");
  static const zero = ValueModel._(raw: "0", numVal: 0, alt: "0");
  static const one = ValueModel._(raw: "1", numVal: 1, alt: "1");

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

    return ValueModel._(
      raw: value,
      alt: value,
      numVal: num,
    );
  }

  factory ValueModel.numeric(num value) {
    double? numVal = !value.isNaN ? value.toDouble() : null;

    return ValueModel._(
      raw: DoubleValueUtils.toPlain(numVal),
      alt: DoubleValueUtils.toScientific(numVal),
      numVal: numVal,
    );
  }

  @override
  List<Object?> get props => [
        raw,
        alt,
        numVal,
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
