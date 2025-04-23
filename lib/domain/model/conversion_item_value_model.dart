import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

abstract class ConversionItemValueModel extends ItemModel {
  final ValueModel value;
  final ValueModel defaultValue;

  const ConversionItemValueModel({
    this.value = ValueModel.empty,
    this.defaultValue = ValueModel.empty,
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
    required super.value,
    required super.defaultValue,
  });

  const ConversionUnitValueModel.fromUnit({
    required UnitModel unit,
  }) : this(
          unit: unit,
          value: ValueModel.empty,
          defaultValue: ValueModel.empty,
        );

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

  bool get valueExists => value.isNotEmpty == true;

  bool get defaultValueExists => defaultValue.isNotEmpty == true;

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
      "value": value.toJson(),
      "defaultValue": defaultValue.toJson(),
    };
  }

  static ConversionUnitValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionUnitValueModel(
      unit: UnitModel.fromJson(json["unit"])!,
      value: ValueModel.fromJson(json["value"]) ?? ValueModel.empty,
      defaultValue:
          ValueModel.fromJson(json["defaultValue"]) ?? ValueModel.empty,
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
      "value": value.toJson(),
      "defaultValue": defaultValue.toJson(),
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
      value: ValueModel.fromJson(json["value"]) ?? ValueModel.empty,
      defaultValue:
          ValueModel.fromJson(json["defaultValue"]) ?? ValueModel.empty,
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
