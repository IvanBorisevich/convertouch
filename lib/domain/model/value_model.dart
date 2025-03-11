import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/list_value_type.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const empty = ValueModel._(raw: "", numVal: null, alt: "");
  static const undef = ValueModel._(raw: "-", numVal: double.nan, alt: "-");
  static const zero = ValueModel._(raw: "0", numVal: 0, alt: "0");
  static const one = ValueModel._(raw: "1", numVal: 1, alt: "1");

  final String raw;
  final String alt;
  final double? numVal;
  final ConvertouchListType listType;

  const ValueModel._({
    required this.raw,
    required this.alt,
    required this.numVal,
    this.listType = ConvertouchListType.none,
  });

  factory ValueModel.str(String? value) {
    double? num = double.tryParse(value ?? "");

    return ValueModel._(
      raw: value ?? "",
      alt: value ?? "",
      numVal: num,
    );
  }

  factory ValueModel.numeric(num? value) {
    if (value == null) {
      return empty;
    }

    if (value.isNaN) {
      return undef;
    }

    double numVal = value.toDouble();

    return ValueModel._(
      raw: DoubleValueUtils.toPlain(numVal),
      alt: DoubleValueUtils.toScientific(numVal),
      numVal: numVal,
    );
  }

  factory ValueModel.rawListVal(
    String? value, {
    required ConvertouchListType listType,
  }) {
    if (value == null) {
      return empty;
    }

    if (!listType.contains(value)) {
      return undef;
    }

    return ValueModel._(
      raw: value,
      alt: "",
      numVal: null,
      listType: listType,
    );
  }

  factory ValueModel.listVal(ListValueType? listValue) {
    if (listValue == null) {
      return empty;
    }

    return ValueModel._(
      raw: listValue.itemName,
      alt: "",
      numVal: null,
      listType: ConvertouchListType.byListValue(listValue),
    );
  }

  factory ValueModel.ofType(String? raw, ConvertouchValueType type) {
    switch (type) {
      case ConvertouchValueType.gender:
      case ConvertouchValueType.garment:
        return ValueModel.rawListVal(raw, listType: type.listType);
      case ConvertouchValueType.text:
      case ConvertouchValueType.integerPositive:
      case ConvertouchValueType.integer:
      case ConvertouchValueType.decimalPositive:
      case ConvertouchValueType.decimal:
      default:
        return ValueModel.str(raw);
    }
  }

  bool get isEmpty => raw.isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool get isUndef => numVal?.isNaN == true;

  @override
  List<Object?> get props => [
        raw,
      ];

  Map<String, dynamic> toJson() {
    return {
      "raw": raw,
      "alt": alt,
      "num": numVal,
      "listType": listType.val != 0 ? listType.val : null,
    };
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ValueModel._(
      raw: json["raw"] ?? "",
      numVal: json["num"] ?? double.tryParse(json["raw"] ?? ""),
      alt: json["alt"] ?? json["scientific"],
      listType: ConvertouchListType.valueOf(json["listType"]),
    );
  }

  @override
  String toString() {
    return 'ValueModel{raw: $raw, alt: $alt, num: $numVal, listType: $listType}';
  }
}
