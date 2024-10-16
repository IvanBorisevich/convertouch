import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const ValueModel none = ValueModel(
    str: "",
    scientific: "",
  );

  static const ValueModel undefined = ValueModel(
    str: "-",
    scientific: "-",
  );

  static const ValueModel one = ValueModel(
    str: "1",
    scientific: "1",
  );

  final double? num;
  final String str;
  final String scientific;

  const ValueModel({
    this.num,
    required this.str,
    required this.scientific,
  });

  factory ValueModel.ofDouble(double? value) {
    if (value == null) {
      return ValueModel.none;
    }

    return ValueModel(
      num: value,
      str: DoubleValueUtils.format(value),
      scientific: DoubleValueUtils.formatScientific(value),
    );
  }

  factory ValueModel.ofString(String? value) {
    if (value == null) {
      return ValueModel.none;
    }

    var numVal = double.tryParse(value);

    return ValueModel(
      num: numVal,
      str: value,
      scientific: DoubleValueUtils.formatScientific(numVal),
    );
  }

  bool get isDefined => exists && this != undefined;

  bool get exists => this != none;

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
    return "{num: $num; str: $str; sc: $scientific}";
  }
}
