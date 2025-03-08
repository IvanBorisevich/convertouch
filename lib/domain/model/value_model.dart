import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const empty = ValueModel._(raw: "", num: null, alt: "");
  static const nan = ValueModel._(raw: "-", num: double.nan, alt: "-");
  static const one = ValueModel._(raw: "1", num: 1, alt: "1");

  final String raw;
  final String alt;
  final double? num;
  final ConvertouchListValueType listType;

  const ValueModel._({
    required this.raw,
    required this.alt,
    required this.num,
    this.listType = ConvertouchListValueType.none,
  });

  factory ValueModel.str(String? value) {
    double? num = double.tryParse(value ?? "");

    return ValueModel._(
      raw: value ?? "",
      alt: value ?? "",
      num: num,
    );
  }

  factory ValueModel.num(double? value) {
    return ValueModel._(
      raw: DoubleValueUtils.toPlain(value),
      alt: DoubleValueUtils.toScientific(value),
      num: value,
    );
  }

  factory ValueModel.list(String? value, ConvertouchListValueType listType) {
    return ValueModel._(
      raw: value ?? "-",
      alt: "",
      num: null,
      listType: listType,
    );
  }

  bool get exists => raw.isNotEmpty;

  @override
  List<Object?> get props => [
        raw,
      ];

  Map<String, dynamic> toJson() {
    return {
      "raw": raw,
      "alt": alt,
      "num": num,
      "listType": listType.val,
    };
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ValueModel._(
      raw: json["raw"] ?? "",
      num: json["num"] ?? double.tryParse(json["raw"] ?? ""),
      alt: json["alt"] ?? json["scientific"],
      listType: ConvertouchListValueType.valueOf(json["listType"]),
    );
  }

  @override
  String toString() {
    return 'ValueModel{raw: $raw, alt: $alt, num: $num, listType: $listType}';
  }
}
