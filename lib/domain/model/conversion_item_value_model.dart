import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef OutputListValuesBatch
    = OutputItemsFetchModel<ListValueModel, ListValuesFetchParams>;

abstract class ConversionItemValueModel extends ItemModel {
  final ValueModel? value;
  final ValueModel? defaultValue;
  final OutputListValuesBatch? listValues;

  const ConversionItemValueModel({
    this.value,
    this.defaultValue,
    this.listValues,
  }) : super(
          itemType: ItemType.conversionItemValue,
        );

  String get name;

  ValueModel? get eitherValue => value ?? defaultValue;

  String? get eitherRaw => eitherValue?.raw;

  String? get raw => value?.raw;

  String? get defaultRaw => defaultValue?.raw;

  num? get eitherNum => eitherValue?.numVal;

  num? get numVal => value?.numVal;

  num? get defaultNumVal => defaultValue?.numVal;

  ConvertouchValueType get valueType;

  ConvertouchListType? get listType;

  UnitModel? get unitItem;

  bool get hasValue {
    return listType != null && value != null ||
        listType == null && (value != null || defaultValue != null);
  }

  @override
  List<Object?> get props => [
        itemType,
        value,
        defaultValue,
        listValues,
      ];
}

class ConversionUnitValueModel extends ConversionItemValueModel {
  final UnitModel unit;

  const ConversionUnitValueModel({
    required this.unit,
    super.value,
    super.defaultValue,
    super.listValues,
  });

  factory ConversionUnitValueModel.tuple(
    UnitModel unit,
    dynamic value,
    dynamic defaultValue, {
    OutputListValuesBatch? listValues,
  }) {
    return ConversionUnitValueModel(
      unit: unit,
      value: ValueModel.any(value),
      defaultValue: ValueModel.any(defaultValue),
      listValues: listValues,
    );
  }

  ConversionUnitValueModel copyWith({
    UnitModel? unit,
    ValueModel? value,
    ValueModel? defaultValue,
    OutputListValuesBatch? listValues,
  }) {
    return ConversionUnitValueModel(
      unit: unit ?? this.unit,
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
      listValues: listValues ?? this.listValues,
    );
  }

  @override
  String get name => unit.name;

  @override
  ConvertouchValueType get valueType => unit.valueType;

  @override
  ConvertouchListType? get listType => unit.listType;

  @override
  UnitModel? get unitItem => unit;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "unit": unit.toJson(removeNulls: removeNulls),
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
      "listValues": listValues?.toJson(
        removeNulls: removeNulls,
        saveParams: false,
      ),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ConversionUnitValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionUnitValueModel(
      unit: UnitModel.fromJson(json["unit"])!,
      value: ValueModel.fromJson(json["value"]),
      defaultValue: ValueModel.fromJson(json["defaultValue"]),
      listValues: OutputItemsFetchModel.fromJson(
        json["listValues"],
        fromItemJson: (e) => ListValueModel.fromJson(e)!,
        fromParamsJson: (e) => ListValuesFetchParams.fromJson(e),
      ),
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
        'unit: ${unit.code}, '
        'value: $value, '
        'default: $defaultValue, '
        'listValues: $listValues}';
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
    super.listValues,
  });

  factory ConversionParamValueModel.tuple(
    ConversionParamModel param,
    dynamic value,
    dynamic defaultValue, {
    bool calculated = false,
    UnitModel? unit,
    OutputListValuesBatch? listValues,
  }) {
    return ConversionParamValueModel(
      param: param,
      unit: unit,
      calculated: calculated,
      value: ValueModel.any(value),
      defaultValue: ValueModel.any(defaultValue),
      listValues: listValues,
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
    UnitModel? unit,
    bool? calculated,
    ValueModel? value,
    ValueModel? defaultValue,
    OutputListValuesBatch? listValues,
  }) {
    return ConversionParamValueModel(
      param: param,
      unit: unit ?? this.unit,
      calculated: calculated ?? this.calculated,
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
      listValues: listValues ?? this.listValues,
    );
  }

  @override
  ConvertouchValueType get valueType => param.valueType;

  @override
  ConvertouchListType? get listType => param.listType;

  @override
  UnitModel? get unitItem => unit ?? param.defaultUnit;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "param": param.toJson(removeNulls: removeNulls),
      "unit": unit?.toJson(removeNulls: removeNulls),
      "calculated": calculated,
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
      "listValues": listValues?.toJson(
        removeNulls: removeNulls,
        saveParams: false,
      ),
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
      listValues: OutputItemsFetchModel.fromJson(
        json['listValues'],
        fromItemJson: (e) => ListValueModel.fromJson(e)!,
        fromParamsJson: (e) => ListValuesFetchParams.fromJson(e),
      ),
    );
  }

  @override
  String toString() {
    return 'ConversionParamValueModel{'
        'param: ${param.name}, '
        'unit: ${unit?.code}, '
        'calculated: $calculated, '
        'value: $value, '
        'default: $defaultValue, '
        'listValues: $listValues}';
  }
}
