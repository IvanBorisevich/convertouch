import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:equatable/equatable.dart';

class ConversionParamSetValueBulkModel extends Equatable {
  final List<ConversionParamSetValueModel> paramSetValues;
  final int selectedIndex;
  final bool paramSetsCanBeAdded;
  final bool selectedParamSetCanBeRemoved;
  final bool paramSetsCanBeRemovedInBulk;
  final bool mandatoryParamSetExists;
  final int totalCount;

  const ConversionParamSetValueBulkModel({
    required this.paramSetValues,
    this.selectedIndex = 0,
    this.paramSetsCanBeAdded = false,
    this.selectedParamSetCanBeRemoved = false,
    this.paramSetsCanBeRemovedInBulk = false,
    this.mandatoryParamSetExists = false,
    this.totalCount = 1,
  });

  ConversionParamSetValueBulkModel copyWith({
    List<ConversionParamSetValueModel>? paramSetValues,
    int? selectedIndex,
    bool? paramSetsCanBeAdded,
    bool? selectedParamSetCanBeRemoved,
    bool? paramSetsCanBeRemovedInBulk,
    bool? mandatoryParamSetExists,
    int? totalCount,
  }) {
    return ConversionParamSetValueBulkModel(
      paramSetValues: paramSetValues ?? this.paramSetValues,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      paramSetsCanBeAdded: paramSetsCanBeAdded ?? this.paramSetsCanBeAdded,
      selectedParamSetCanBeRemoved:
          selectedParamSetCanBeRemoved ?? this.selectedParamSetCanBeRemoved,
      paramSetsCanBeRemovedInBulk:
          paramSetsCanBeRemovedInBulk ?? this.paramSetsCanBeRemovedInBulk,
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

    int paramIndex =
        paramSetValues[paramSetIndex].paramValues.indexWhere(paramFilter);

    if (paramIndex < 0) {
      return this;
    }

    List<ConversionParamValueModel> newParamValues = [
      ...paramSetValues[paramSetIndex].paramValues
    ];

    newParamValues[paramIndex] = await map.call(
      paramSetValues[paramSetIndex].paramValues[paramIndex],
      paramSetValues[paramSetIndex],
    );

    List<ConversionParamSetValueModel> newParamSetValues = [...paramSetValues];
    newParamSetValues[paramSetIndex] = paramSetValues[paramSetIndex].copyWith(
      paramValues: newParamValues,
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
        paramSetsCanBeRemovedInBulk,
        mandatoryParamSetExists,
        totalCount,
      ];

  Map<String, dynamic> toJson() {
    return {
      "paramSetValues": paramSetValues.map((item) => item.toJson()).toList(),
      "selectedIndex": selectedIndex,
      "paramSetsCanBeAdded": paramSetsCanBeAdded,
      "paramSetCanBeRemoved": selectedParamSetCanBeRemoved,
      "paramSetsCanBeRemovedInBulk": paramSetsCanBeRemovedInBulk,
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
      paramSetsCanBeRemovedInBulk: json["paramSetsCanBeRemovedInBulk"] ?? false,
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
        'paramSetsCanBeRemovedInBulk: $paramSetsCanBeRemovedInBulk, '
        'mandatoryParamSetExists: $mandatoryParamSetExists, '
        'totalCount: $totalCount}';
  }
}
