import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef ListValuesFetchResult
    = OutputItemsFetchModel<ValueModel, ListValuesFetchParams>;

typedef UnitValueRecord = (
  UnitModel,
  dynamic,
  dynamic, {
  ListValuesFetchResult? listValuesFetchResult,
});

typedef UnitValueRawRecord = (
  UnitModel,
  dynamic,
  dynamic, {
  ListValuesFetchResult? listValuesFetchResult,
});

typedef ParamValueRecord = (
  ConversionParamModel,
  dynamic,
  dynamic, {
  ListValuesFetchResult? listValuesFetchResult,
  UnitModel? unit,
  bool calculated
});

typedef ParamValueRawRecord = (
  ConversionParamModel,
  dynamic,
  dynamic, {
  ListValuesFetchResult? listValuesFetchResult,
  UnitModel? unit,
  bool calculated
});

class ItemValueModel extends ItemModel {
  final ValueModel? value;
  final ValueModel? defaultValue;
  final ListValuesFetchResult? listValuesFetchResult;

  const ItemValueModel({
    this.value,
    this.defaultValue,
    this.listValuesFetchResult,
  }) : super(
          itemType: ItemType.itemValue,
        );

  String get id => "";

  String? get name => null;

  ValueModel? get eitherValue => value ?? defaultValue;

  String? get eitherRaw => eitherValue?.raw;

  String? get raw => value?.raw;

  String? get defaultRaw => defaultValue?.raw;

  num? get eitherNum => eitherValue?.numVal;

  num? get numVal => value?.numVal;

  num? get defaultNumVal => defaultValue?.numVal;

  double? get min => unitItem?.minValue?.numVal ?? valueType.min;

  double? get max => unitItem?.maxValue?.numVal;

  ConvertouchValueType get valueType => ConvertouchValueType.text;

  ConvertouchListType? get listType => null;

  UnitModel? get unitItem => null;

  ItemValueModel copyWith({
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ItemValueModel(
      value: patchValueModel(thisValue: this.value, newValue: value),
      defaultValue: patchValueModel(
        thisValue: this.defaultValue,
        newValue: defaultValue,
      ),
      listValuesFetchResult:
          listValuesFetchResult ?? this.listValuesFetchResult,
    );
  }

  bool get hasValue {
    return listType != null && value != null ||
        listType == null && (value != null || defaultValue != null);
  }

  @override
  List<Object?> get props => [
        itemType,
        value,
        defaultValue,
        listValuesFetchResult,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }
}

class ConversionUnitValueModel extends ItemValueModel {
  final UnitModel unit;

  const ConversionUnitValueModel({
    required this.unit,
    super.value,
    super.defaultValue,
    super.listValuesFetchResult,
  });

  factory ConversionUnitValueModel.tuple(
    UnitModel unit,
    dynamic value,
    dynamic defaultValue, {
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionUnitValueModel(
      unit: unit,
      value: ValueModel.any(value),
      defaultValue: ValueModel.any(defaultValue),
      listValuesFetchResult: listValuesFetchResult,
    );
  }

  @override
  ConversionUnitValueModel copyWith({
    UnitModel? unit,
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionUnitValueModel(
      unit: unit ?? this.unit,
      value: patchValueModel(thisValue: this.value, newValue: value),
      defaultValue: patchValueModel(
        thisValue: this.defaultValue,
        newValue: defaultValue,
      ),
      listValuesFetchResult:
          listValuesFetchResult ?? this.listValuesFetchResult,
    );
  }

  @override
  String get id => unitValueKey(unit.id);

  @override
  String get name => unit.itemName;

  @override
  ConvertouchValueType get valueType => unit.valueType;

  @override
  ConvertouchListType? get listType => unit.listType;

  @override
  UnitModel? get unitItem => unit;

  @override
  List<Object?> get props => [
        unit,
        super.props,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "unit": unit.toJson(removeNulls: removeNulls),
      "value": value?.toJson(),
      "defaultValue": defaultValue?.toJson(),
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
    );
  }

  @override
  String toString() {
    return 'UnitValue{id = $id | $value | alt = $defaultValue | ${unit.code} | '
        'list size: ${listValuesFetchResult?.items.length}}';
  }
}

class ConversionParamValueModel extends ItemValueModel {
  final ConversionParamModel param;
  final UnitModel? unit;
  final bool calculated;

  const ConversionParamValueModel({
    required this.param,
    this.unit,
    this.calculated = false,
    super.value,
    super.defaultValue,
    super.listValuesFetchResult,
  });

  factory ConversionParamValueModel.tuple(
    ConversionParamModel param,
    dynamic value,
    dynamic defaultValue, {
    bool calculated = false,
    UnitModel? unit,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionParamValueModel(
      param: param,
      unit: unit,
      calculated: calculated,
      value: ValueModel.any(value),
      defaultValue: ValueModel.any(defaultValue),
      listValuesFetchResult: listValuesFetchResult,
    );
  }

  @override
  ConversionParamValueModel copyWith({
    ConversionParamModel? param,
    UnitModel? unit,
    bool? calculated,
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionParamValueModel(
      param: param ?? this.param,
      unit: unit ?? this.unit,
      calculated: calculated ?? this.calculated,
      value: patchValueModel(thisValue: this.value, newValue: value),
      defaultValue: patchValueModel(
        thisValue: this.defaultValue,
        newValue: defaultValue,
      ),
      listValuesFetchResult:
          listValuesFetchResult ?? this.listValuesFetchResult,
    );
  }

  @override
  String get id => paramValueKey(param.id);

  @override
  String? get name => param.name;

  @override
  ConvertouchValueType get valueType => param.valueType;

  @override
  ConvertouchListType? get listType => param.listType;

  @override
  UnitModel? get unitItem => unit ?? param.defaultUnit;

  @override
  List<Object?> get props => [
        param,
        unit,
        calculated,
        super.props,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "param": param.toJson(removeNulls: removeNulls),
      "unit": unit?.toJson(removeNulls: removeNulls),
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
    return 'ParamValue{${param.name}: $value , $defaultValue | ${unit?.code} | '
        'list size: ${listValuesFetchResult?.items.length}}';
  }
}

String unitValueKey(int unitId) => "unitValue_$unitId";

String paramValueKey(int paramId) => "paramValue_$paramId";
