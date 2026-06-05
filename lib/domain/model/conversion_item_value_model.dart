import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:rxdart/rxdart.dart';

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

abstract class ConversionItemValueModel extends ItemModel {
  final ValueModel? value;
  final ValueModel? defaultValue;
  final BehaviorSubject<ListValuesFetchResult?> listValuesBatchStream;

  const ConversionItemValueModel({
    this.value,
    this.defaultValue,
    required this.listValuesBatchStream,
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

  double? get min => unitItem?.minValue?.numVal ?? valueType.min;

  double? get max => unitItem?.maxValue?.numVal;

  ConvertouchValueType get valueType;

  ConvertouchListType? get listType;

  UnitModel? get unitItem;

  ListValuesFetchResult? get listValuesFetchResult =>
      listValuesBatchStream.valueOrNull;

  ConversionItemValueModel copyWith({
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  });

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
}

class ConversionUnitValueModel extends ConversionItemValueModel {
  final UnitModel unit;

  const ConversionUnitValueModel._({
    required this.unit,
    super.value,
    super.defaultValue,
    required super.listValuesBatchStream,
  });

  factory ConversionUnitValueModel({
    required UnitModel unit,
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionUnitValueModel._(
      unit: unit,
      value: value,
      defaultValue: defaultValue,
      listValuesBatchStream: BehaviorSubject.seeded(listValuesFetchResult),
    );
  }

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
    return ConversionUnitValueModel._(
      unit: unit ?? this.unit,
      value: patchValueModel(thisValue: this.value, newValue: value),
      defaultValue: patchValueModel(
        thisValue: this.defaultValue,
        newValue: defaultValue,
      ),
      listValuesBatchStream: listValuesFetchResult != null
          ? (listValuesBatchStream..add(listValuesFetchResult))
          : listValuesBatchStream,
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
      "listValues": listValuesFetchResult?.toJson(
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
      listValuesFetchResult: OutputItemsFetchModel.fromJson(
        json["listValues"],
        fromItemJson: (e) => ValueModel.fromJson(e)!,
        fromParamsJson: (e) => ListValuesFetchParams.fromJson(e),
      ),
    );
  }

  @override
  String toString() {
    return 'ConversionUnitValueModel{'
        'unit: ${unit.code}, '
        'value: $value, '
        'default: $defaultValue, '
        'listValues: $listValuesFetchResult}';
  }
}

class ConversionParamValueModel extends ConversionItemValueModel {
  final ConversionParamModel param;
  final UnitModel? unit;
  final bool calculated;

  const ConversionParamValueModel._({
    required this.param,
    this.unit,
    this.calculated = false,
    super.value,
    super.defaultValue,
    required super.listValuesBatchStream,
  });

  factory ConversionParamValueModel({
    required ConversionParamModel param,
    UnitModel? unit,
    bool calculated = false,
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return ConversionParamValueModel._(
      param: param,
      unit: unit,
      calculated: calculated,
      value: value,
      defaultValue: defaultValue,
      listValuesBatchStream: BehaviorSubject.seeded(listValuesFetchResult),
    );
  }

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

  @override
  ConversionParamValueModel copyWith({
    ConversionParamModel? param,
    UnitModel? unit,
    bool? calculated,
    ValueModel? value,
    ValueModel? defaultValue,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    print(
        "[ConversionParamValueModel] name: ${this.param.name}, stream id = ${listValuesBatchStream.hashCode}");

    return ConversionParamValueModel._(
      param: param ?? this.param,
      unit: unit ?? this.unit,
      calculated: calculated ?? this.calculated,
      value: patchValueModel(thisValue: this.value, newValue: value),
      defaultValue:
          patchValueModel(thisValue: this.defaultValue, newValue: defaultValue),
      listValuesBatchStream: listValuesFetchResult != null
          ? (listValuesBatchStream..add(listValuesFetchResult))
          : listValuesBatchStream,
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
      "listValues": listValuesFetchResult?.toJson(
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
      listValuesFetchResult: OutputItemsFetchModel.fromJson(
        json['listValues'],
        fromItemJson: (e) => ValueModel.fromJson(e)!,
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
        'listValues: $listValuesFetchResult}';
  }
}
