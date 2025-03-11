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
          itemType: ItemType.conversionItem,
        );

  String get name;

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

  ConversionUnitValueModel.coalesce(
    ConversionUnitValueModel? saved, {
    UnitModel? unit,
    ValueModel? value,
    ValueModel? defaultValue,
  }) : this(
          unit: unit ?? saved?.unit ?? UnitModel.none,
          value: value ?? saved?.value ?? ValueModel.empty,
          defaultValue: defaultValue ?? saved?.defaultValue ?? ValueModel.empty,
        );

  bool get valueExists => value.isNotEmpty == true;

  bool get defaultValueExists => defaultValue.isNotEmpty == true;

  @override
  String get name => unit.name;

  @override
  Map<String, dynamic> toJson() {
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

  const ConversionParamValueModel({
    required this.param,
    super.value,
    super.defaultValue,
  });

  @override
  List<Object?> get props => [
        param,
        super.props,
      ];

  @override
  String get name => param.fullName;

  @override
  Map<String, dynamic> toJson() {
    return {
      "param": param,
      "value": value.toJson(),
      "defaultValue": defaultValue.toJson(),
    };
  }

  static ConversionParamValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamValueModel(
      param: ConversionParamModel.fromJson(json["param"])!,
      value: ValueModel.fromJson(json["value"]) ?? ValueModel.empty,
      defaultValue:
          ValueModel.fromJson(json["defaultValue"]) ?? ValueModel.empty,
    );
  }

  @override
  String toString() {
    return 'ConversionParamValueModel{'
        'param: $param, '
        'value: $value, '
        'default: $defaultValue'
        '}';
  }
}
