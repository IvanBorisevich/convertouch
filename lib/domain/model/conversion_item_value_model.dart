import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/list_values.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

abstract class ConversionItemValueModel extends ItemModel {
  final ValueModel? value;
  final ValueModel? defaultValue;

  const ConversionItemValueModel({
    this.value,
    this.defaultValue,
  }) : super(
          itemType: ItemType.conversionItemValue,
        );

  String get name;

  ConvertouchValueType get valueType;

  ConvertouchListType? get listType;

  @override
  List<Object?> get props => [
        itemType,
        value,
        defaultValue,
      ];
}

class ConversionUnitValueModel extends ConversionItemValueModel {
  final UnitModel unit;

  const ConversionUnitValueModel({
    required this.unit,
    super.value,
    super.defaultValue,
  });

  factory ConversionUnitValueModel.wrap({
    required UnitModel unit,
    required String? value,
    required String? defaultValue,
  }) {
    String? presetDefaultValueStr;

    if (unit.listType != null && unit.listType!.isFirstValueDefault) {
      presetDefaultValueStr = listableSets[unit.listType]!.first;
    } else {
      presetDefaultValueStr = unit.valueType.defaultValueStr;
    }

    ValueModel? presetDefaultValue = presetDefaultValueStr != null
        ? ValueModel.str(presetDefaultValueStr)
        : null;

    return ConversionUnitValueModel(
      unit: unit,
      value: value != null ? ValueModel.str(value) : null,
      defaultValue: defaultValue != null
          ? ValueModel.str(defaultValue)
          : presetDefaultValue,
    );
  }

  ConversionUnitValueModel copyWith({
    UnitModel? unit,
    ValueModel? value,
    ValueModel? defaultValue,
  }) {
    return ConversionUnitValueModel(
      unit: unit ?? this.unit,
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  @override
  String get name => unit.name;

  @override
  ConvertouchValueType get valueType => unit.valueType;

  @override
  ConvertouchListType? get listType => unit.listType;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    return {
      "unit": unit.toJson(),
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
    };
  }

  static ConversionUnitValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionUnitValueModel(
      unit: UnitModel.fromJson(json["unit"])!,
      value: ValueModel.fromJson(json["value"]),
      defaultValue: ValueModel.fromJson(json["defaultValue"]),
    );
  }

  @override
  List<Object?> get props => [
        unit,
        super.props,
      ];

  @override
  String toString() {
    return 'ConversionUnitValueModel{'
        'unit id: ${unit.id}, '
        'name: ${unit.name}, '
        'coefficient: ${unit.coefficient}, '
        'value: $value, '
        'default: $defaultValue'
        '}';
  }
}

class ConversionParamValueModel extends ConversionItemValueModel {
  final ConversionParamModel param;
  final UnitModel? unit;
  final bool calculated;

  const ConversionParamValueModel({
    required this.param,
    this.unit,
    this.calculated = false,
    super.value,
    super.defaultValue,
  });

  factory ConversionParamValueModel.wrap({
    required ConversionParamModel param,
    UnitModel? unit,
    bool calculated = false,
    String? value,
    String? defaultValue,
  }) {
    String? presetDefaultValueStr;

    if (param.listType != null && param.listType!.isFirstValueDefault) {
      presetDefaultValueStr = listableSets[param.listType]!.first;
    } else {
      presetDefaultValueStr = param.valueType.defaultValueStr;
    }

    ValueModel? presetDefaultValue = presetDefaultValueStr != null
        ? ValueModel.str(presetDefaultValueStr)
        : null;

    return ConversionParamValueModel(
      param: param,
      unit: unit,
      calculated: calculated,
      value: value != null ? ValueModel.str(value) : null,
      defaultValue: defaultValue != null
          ? ValueModel.str(defaultValue)
          : presetDefaultValue,
    );
  }

  @override
  List<Object?> get props => [
        param,
        unit,
        calculated,
        super.props,
      ];

  @override
  String get name {
    if (unit != null) {
      return "${param.name} | ${unit!.name}";
    }

    return param.name;
  }

  ConversionParamValueModel copyWith({
    ConversionParamModel? param,
    UnitModel? unit,
    bool? calculated,
    ValueModel? value,
    ValueModel? defaultValue,
  }) {
    return ConversionParamValueModel(
      param: param ?? this.param,
      unit: unit ?? this.unit,
      calculated: calculated ?? this.calculated,
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  @override
  ConvertouchValueType get valueType => param.valueType;

  @override
  ConvertouchListType? get listType => param.listType;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "param": param.toJson(),
      "unit": unit?.toJson(),
      "calculated": calculated,
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ConversionParamValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamValueModel(
      param: ConversionParamModel.fromJson(json["param"])!,
      unit: UnitModel.fromJson(json["unit"]),
      calculated: json["calculated"],
      value: ValueModel.fromJson(json["value"]),
      defaultValue: ValueModel.fromJson(json["defaultValue"]),
    );
  }

  @override
  String toString() {
    return 'ConversionParamValueModel{'
        'param: $param, '
        'unit: $unit, '
        'calculated: $calculated, '
        'value: $value, '
        'default: $defaultValue'
        '}';
  }
}
