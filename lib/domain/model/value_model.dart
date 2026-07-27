import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';

class ValueModel extends IdNameSearchableItemModel {
  static const zero = ValueModel(raw: "0", numVal: 0, alt: "0", range: null);
  static const one = ValueModel(raw: "1", numVal: 1, alt: "1", range: null);

  final String raw;
  final String? alt;
  final double? numVal;
  final NumRange? range;
  final String? iconUri;

  const ValueModel({
    required this.raw,
    required this.alt,
    this.numVal,
    this.range,
    this.iconUri,
  }) : super(
          id: -1,
          name: '',
          itemType: ItemType.value,
          oob: false,
        );

  const ValueModel.rawStr(String value, {String? alt, String? iconUri})
      : this(
          raw: value,
          alt: alt ?? value,
          numVal: null,
          range: null,
          iconUri: iconUri,
        );

  factory ValueModel.str(
    String value, {
    String? alt,
    String? iconUri,
  }) {
    double? num = double.tryParse(value);

    if (num != null) {
      return ValueModel.num(num, alt: alt);
    }

    return ValueModel(
      raw: value,
      alt: alt ?? value,
      numVal: num,
      range: null,
      iconUri: iconUri,
    );
  }

  factory ValueModel.num(
    num value, {
    String? alt,
    String? iconUri,
  }) {
    double? numVal = !value.isNaN ? value.toDouble() : null;

    String raw = DoubleValueUtils.format(numVal);

    return ValueModel(
      raw: raw,
      alt: alt ?? DoubleValueUtils.format(numVal, scientific: true),
      numVal: double.tryParse(raw),
      range: null,
      iconUri: iconUri,
    );
  }

  factory ValueModel.range(
    NumRange range, {
    String? iconUri,
  }) {
    return ValueModel(
      raw: range.rangeName,
      alt: range.rangeName,
      numVal: null,
      range: range,
      iconUri: iconUri,
    );
  }

  static ValueModel? any(
    dynamic value, {
    String? iconUri,
  }) {
    if (value == null) {
      return null;
    }

    if (value is ValueModel) {
      return value.copyWith(iconUri: iconUri);
    }

    if (value is num) {
      return ValueModel.num(value, iconUri: iconUri);
    }

    if (value is String) {
      return value.isNotEmpty ? ValueModel.str(value, iconUri: iconUri) : null;
    }

    if (value is NumRange) {
      return ValueModel.range(value, iconUri: iconUri);
    }

    throw ConvertouchException(message: "Value $value has unsupported type");
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
    String? iconUri,
  }) {
    return ValueModel(
      raw: raw ?? this.raw,
      alt: alt ?? this.alt,
      numVal: numVal ?? this.numVal,
      range: range ?? this.range,
      iconUri: iconUri ?? this.iconUri,
    );
  }

  bool get hasRawValue => raw.isNotEmpty;

  @override
  String get itemName => alt ?? raw;

  @override
  List<Object?> get props => [
        raw,
        alt,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "raw": raw,
      "alt": alt,
      "num": numVal,
      "range": range?.toJson(removeNulls: removeNulls),
      "iconUri": iconUri,
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

    String? raw = json["raw"] ?? json["value"];
    if (raw == null || raw == '') {
      return null;
    }

    return ValueModel(
      raw: raw,
      numVal: double.tryParse(json["num"]?.toString() ?? "") ??
          double.tryParse(raw),
      alt: json["alt"] ?? json["scientific"] ?? raw,
      range: NumRange.fromJson(json["range"]),
      iconUri: json["iconUri"],
    );
  }

  @override
  String toString() {
    return '{$raw , $alt'
        '${iconUri != null ? ", icon: $iconUri" : ""}}';
  }
}
