import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionParamSetValueModel extends ItemModel {
  final ConversionParamSetModel paramSet;
  final List<ConversionParamValueModel> paramValues;

  const ConversionParamSetValueModel({
    required this.paramSet,
    required this.paramValues,
  }) : super(
          itemType: ItemType.conversionParamSetValue,
        );

  const ConversionParamSetValueModel.tuple(this.paramSet, this.paramValues)
      : super(
          itemType: ItemType.conversionParamSetValue,
        );

  factory ConversionParamSetValueModel.compact({
    required ConversionParamSetModel paramSet,
    required List<
            (
              ConversionParamModel,
              dynamic,
              dynamic, {
              OutputListValuesBatch? listValues,
              UnitModel? unit,
              bool calculated
            })>
        paramValues,
  }) {
    return ConversionParamSetValueModel(
      paramSet: paramSet,
      paramValues: paramValues
          .map(
            (r) => ConversionParamValueModel.tuple(
              r.$1,
              r.$2,
              r.$3,
              listValues: r.listValues,
              unit: r.unit,
              calculated: r.calculated,
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        paramSet,
        paramValues,
      ];

  bool get hasAllValues => paramValues.every((p) => p.hasValue);

  T? getValueOfType<T>(
    String paramName,
    T? Function(String?) rawMap,
  ) {
    var paramValue = getParamValue(paramName);
    return rawMap.call(paramValue?.raw);
  }

  ConversionParamValueModel? getParamValue(String paramName) {
    return paramValues.firstWhereOrNull((e) => e.param.name == paramName);
  }

  ConversionParamValueModel? getParamValueById(int id) {
    return paramValues.firstWhereOrNull((e) => e.param.id == id);
  }

  bool hasParamValue(String paramName) {
    return paramValues.any((e) => e.param.name == paramName && e.hasValue);
  }

  bool get hasMultipleCalculableParams {
    return paramValues.where((p) => p.param.calculable).length > 1;
  }

  ConversionParamSetValueModel copyWith({
    ConversionParamSetModel? paramSet,
    List<ConversionParamValueModel>? paramValues,
  }) {
    return ConversionParamSetValueModel(
      paramSet: paramSet ?? this.paramSet,
      paramValues: paramValues ?? this.paramValues,
    );
  }

  ConversionParamSetValueModel copyWithNewCalculatedParam({
    required int newCalculatedParamId,
  }) {
    List<ConversionParamValueModel> newParamValues = paramValues
        .map(
          (p) => p.copyWith(
            calculated:
                p.param.id == newCalculatedParamId ? !p.calculated : false,
          ),
        )
        .toList();

    return copyWith(
      paramValues: newParamValues,
    );
  }

  Future<ConversionParamSetValueModel> copyWithChangedParams({
    required Future<ConversionParamValueModel> Function(
      ConversionParamValueModel,
      ConversionParamSetValueModel,
    ) map,
    required bool Function(ConversionParamValueModel) paramFilter,
    bool changeFirstMatchedParamOnly = true,
  }) async {
    List<ConversionParamValueModel> newParamValues = [];
    bool firstParamFound = true;

    for (var paramValue in paramValues) {
      ConversionParamValueModel newParamValue;
      if (paramFilter.call(paramValue) && firstParamFound) {
        newParamValue = await map.call(paramValue, this);
        firstParamFound = !changeFirstMatchedParamOnly;
      } else {
        newParamValue = paramValue;
      }

      newParamValues.add(newParamValue);
    }

    return copyWith(
      paramValues: newParamValues,
    );
  }

  Future<ConversionParamSetValueModel> copyWithChangedParamById({
    required int paramId,
    required Future<ConversionParamValueModel> Function(
      ConversionParamValueModel,
      ConversionParamSetValueModel,
    ) map,
  }) async {
    return await copyWithChangedParams(
      paramFilter: (p) => p.param.id == paramId,
      map: map,
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    return {
      "paramSet": paramSet.toJson(),
      "paramValues": paramValues.map((value) => value.toJson()).toList(),
    };
  }

  static ConversionParamSetValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetValueModel(
      paramSet: ConversionParamSetModel.fromJson(json["paramSet"])!,
      paramValues: (json["paramValues"] as List)
          .map((value) => ConversionParamValueModel.fromJson(value)!)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetValueModel{'
        'paramSet: $paramSet, '
        'paramValues: $paramValues}';
  }
}
