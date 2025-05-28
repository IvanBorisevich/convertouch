import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:equatable/equatable.dart';

class ConversionParamSetValueBulkModel extends Equatable {
  final List<ConversionParamSetValueModel> paramSetValues;
  final int selectedIndex;
  final bool paramSetsCanBeAdded;
  final bool selectedParamSetCanBeRemoved;
  final bool optionalParamSetsExist;
  final bool mandatoryParamSetExists;
  final int totalCount;

  const ConversionParamSetValueBulkModel({
    this.paramSetValues = const [],
    this.selectedIndex = -1,
    this.paramSetsCanBeAdded = false,
    this.selectedParamSetCanBeRemoved = false,
    this.optionalParamSetsExist = false,
    this.mandatoryParamSetExists = false,
    this.totalCount = 1,
  });

  factory ConversionParamSetValueBulkModel.basic({
    List<ConversionParamSetValueModel> paramSetValues = const [],
    int? selectedIndex,
    int totalCount = 1,
  }) {
    int paramSetsListSize = paramSetValues.length;
    int index = selectedIndex ?? paramSetsListSize - 1;

    bool paramSetsCanBeAdded = paramSetsListSize < totalCount;
    bool selectedParamSetCanBeRemoved =
        paramSetValues.isNotEmpty && !paramSetValues[index].paramSet.mandatory;
    bool optionalParamSetsExist = paramSetValues.any(
      (p) => !p.paramSet.mandatory,
    );
    bool mandatoryParamSetExists = paramSetValues.any(
      (p) => p.paramSet.mandatory,
    );

    return ConversionParamSetValueBulkModel(
      paramSetValues: paramSetValues,
      selectedIndex: index,
      paramSetsCanBeAdded: paramSetsCanBeAdded,
      selectedParamSetCanBeRemoved: selectedParamSetCanBeRemoved,
      optionalParamSetsExist: optionalParamSetsExist,
      mandatoryParamSetExists: mandatoryParamSetExists,
      totalCount: totalCount,
    );
  }

  ConversionParamSetValueBulkModel copyWith({
    List<ConversionParamSetValueModel>? paramSetValues,
    int? selectedIndex,
    bool? paramSetsCanBeAdded,
    bool? selectedParamSetCanBeRemoved,
    bool? optionalParamSetsExist,
    bool? mandatoryParamSetExists,
    int? totalCount,
  }) {
    return ConversionParamSetValueBulkModel(
      paramSetValues: paramSetValues ?? this.paramSetValues,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      paramSetsCanBeAdded: paramSetsCanBeAdded ?? this.paramSetsCanBeAdded,
      selectedParamSetCanBeRemoved:
          selectedParamSetCanBeRemoved ?? this.selectedParamSetCanBeRemoved,
      optionalParamSetsExist:
          optionalParamSetsExist ?? this.optionalParamSetsExist,
      mandatoryParamSetExists:
          mandatoryParamSetExists ?? this.mandatoryParamSetExists,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  Future<ConversionParamSetValueBulkModel> copyWithChangedParam({
    required Future<ConversionParamValueModel> Function(
      ConversionParamValueModel,
      ConversionParamSetValueModel,
    ) map,
    bool Function(ConversionParamSetValueModel)? paramSetFilter,
    required bool Function(ConversionParamValueModel) paramFilter,
  }) async {
    int paramSetIndex = paramSetFilter != null
        ? paramSetValues.indexWhere(paramSetFilter)
        : selectedIndex;

    if (paramSetIndex < 0) {
      return this;
    }

    ConversionParamSetValueModel newParamSetValue =
        await paramSetValues[paramSetIndex].copyWithChangedParam(
      map: map,
      paramFilter: paramFilter,
    );

    List<ConversionParamSetValueModel> newParamSetValues = [...paramSetValues];
    newParamSetValues[paramSetIndex] = paramSetValues[paramSetIndex].copyWith(
      paramValues: newParamSetValue.paramValues,
    );

    return copyWith(
      paramSetValues: newParamSetValues,
    );
  }

  Future<ConversionParamSetValueBulkModel> copyWithChangedParamByIds({
    required Future<ConversionParamValueModel> Function(
      ConversionParamValueModel,
      ConversionParamSetValueModel,
    ) map,
    int? paramSetId,
    required int paramId,
  }) async {
    return await copyWithChangedParam(
      map: map,
      paramSetFilter:
          paramSetId != null ? (p) => p.paramSet.id == paramSetId : null,
      paramFilter: (p) => p.param.id == paramId,
    );
  }

  Future<ConversionParamSetValueBulkModel> copyWithChangedParamSet({
    required Future<ConversionParamSetValueModel> Function(
      ConversionParamSetValueModel,
    ) map,
    bool Function(ConversionParamSetValueModel)? paramSetFilter,
  }) async {
    int paramSetIndex = paramSetFilter != null
        ? paramSetValues.indexWhere(paramSetFilter)
        : selectedIndex;

    if (paramSetIndex < 0) {
      return this;
    }

    List<ConversionParamSetValueModel> newParamSetValues = [...paramSetValues];
    newParamSetValues[paramSetIndex] =
        await map.call(paramSetValues[paramSetIndex]);

    return copyWith(
      paramSetValues: newParamSetValues,
    );
  }

  Future<ConversionParamSetValueBulkModel> copyWithChangedParamSetByIds({
    required Future<ConversionParamSetValueModel> Function(
      ConversionParamSetValueModel,
    ) map,
    int? paramSetId,
  }) async {
    return copyWithChangedParamSet(
      map: map,
      paramSetFilter:
          paramSetId != null ? (p) => p.paramSet.id == paramSetId : null,
    );
  }

  ConversionParamSetValueModel? get activeParams {
    return paramSetValues.isNotEmpty && selectedIndex > -1
        ? paramSetValues[selectedIndex]
        : null;
  }

  @override
  List<Object?> get props => [
        paramSetValues,
        selectedIndex,
        paramSetsCanBeAdded,
        selectedParamSetCanBeRemoved,
        optionalParamSetsExist,
        mandatoryParamSetExists,
        totalCount,
      ];

  Map<String, dynamic> toJson() {
    return {
      "paramSetValues": paramSetValues.map((item) => item.toJson()).toList(),
      "selectedIndex": selectedIndex,
      "paramSetsCanBeAdded": paramSetsCanBeAdded,
      "paramSetCanBeRemoved": selectedParamSetCanBeRemoved,
      "optionalParamSetsExist": optionalParamSetsExist,
      "mandatoryParamSetExists": mandatoryParamSetExists,
      "totalCount": totalCount,
    };
  }

  static ConversionParamSetValueBulkModel? fromJson(
      Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ConversionParamSetValueBulkModel(
      paramSetValues: json["paramSetValues"] != null
          ? (json["paramSetValues"] as List)
              .map((item) => ConversionParamSetValueModel.fromJson(item)!)
              .toList()
          : [],
      selectedIndex: json["selectedIndex"] ?? 0,
      paramSetsCanBeAdded: json["paramSetsCanBeAdded"] ?? false,
      selectedParamSetCanBeRemoved: json["paramSetCanBeRemoved"] ?? false,
      optionalParamSetsExist: json["optionalParamSetsExist"] ?? false,
      mandatoryParamSetExists: json["mandatoryParamSetExists"] ?? false,
      totalCount: json["totalCount"] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetValueBulkModel{'
        'paramSetValues: $paramSetValues, '
        'selectedIndex: $selectedIndex, '
        'paramSetsCanBeAdded: $paramSetsCanBeAdded, '
        'selectedParamSetCanBeRemoved: $selectedParamSetCanBeRemoved, '
        'optionalParamSetsExist: $optionalParamSetsExist, '
        'mandatoryParamSetExists: $mandatoryParamSetExists, '
        'totalCount: $totalCount}';
  }
}
