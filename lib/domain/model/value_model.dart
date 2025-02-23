import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const ValueModel none = ValueModel(
    str: "",
    scientific: "",
  );

  static const ValueModel nan = ValueModel(
    str: "-",
    scientific: "-",
  );

  static const ValueModel one = ValueModel(
    num: 1,
    str: "1",
    scientific: "1",
  );

  final double? num;
  final String str;
  final String scientific;

  const ValueModel({
    this.num,
    required this.str,
    required this.scientific,       // TODO: rename to 'altStr' and make optional
  });

  factory ValueModel.ofDouble(double? value) {
    if (value == null) {
      return ValueModel.none;
    }

    return ValueModel(
      num: value,
      str: DoubleValueUtils.toPlain(value),
      scientific: DoubleValueUtils.toScientific(value),
    );
  }

  factory ValueModel.ofString(
    String? value, {
    ValueModel defaultValue = ValueModel.none,
  }) {
    if (value == null) {
      return defaultValue;
    }

    var numVal = double.tryParse(value);

    return ValueModel(
      num: numVal,
      str: value,
      scientific: DoubleValueUtils.toScientific(numVal),
    );
  }

  bool get exists => this != none && this != nan;

  Map<String, dynamic> toJson() {
    return {
      "num": num,
      "raw": str,
      "scientific": scientific,
    };
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ValueModel(
      num: json["num"] ?? double.tryParse(json["raw"] ?? ""),
      str: json["raw"],
      scientific: json["scientific"],
    );
  }

  @override
  List<Object?> get props => [
        num,
        str,
        scientific,
      ];

  @override
  String toString() {
    if (!exists) {
      return "ValueModel.none";
    }
    return "ValueModel{num: $num; str: $str; sc: $scientific}";
  }
}
