import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:equatable/equatable.dart';

class ConversionParamSetValueModel extends ItemModel {
  final ConversionParamSetModel paramSet;
  final List<ConversionParamValueModel> paramValues;

  const ConversionParamSetValueModel({
    required this.paramSet,
    required this.paramValues,
  }) : super(
          itemType: ItemType.conversionParamSetValue,
        );

  @override
  List<Object?> get props => [
        paramSet,
        paramValues,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    return {
      "paramSet": paramSet.toJson(),
      "paramValues": paramValues.map((value) => value.toJson()).toList(),
    };
  }

  ValueModel getValue(String paramName) {
    return paramValues.firstWhere((e) => e.param.name == paramName).value;
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

class ConversionParamSetValueBulkModel extends Equatable {
  final List<ConversionParamSetValueModel> paramSetValues;
  final int selectedIndex;
  final bool paramSetsCanBeAdded;
  final bool selectedParamSetCanBeRemoved;
  final bool paramSetsCanBeRemovedInBulk;

  const ConversionParamSetValueBulkModel({
    this.paramSetValues = const [],
    this.selectedIndex = 0,
    this.paramSetsCanBeAdded = false,
    this.selectedParamSetCanBeRemoved = false,
    this.paramSetsCanBeRemovedInBulk = false,
  });

  ConversionParamSetValueBulkModel copyWith({
    List<ConversionParamSetValueModel>? paramSetValues,
    int? selectedIndex,
    bool? paramSetsCanBeAdded,
    bool? selectedParamSetCanBeRemoved,
    bool? paramSetsCanBeRemovedInBulk,
  }) {
    return ConversionParamSetValueBulkModel(
      paramSetValues: paramSetValues ?? this.paramSetValues,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      paramSetsCanBeAdded: paramSetsCanBeAdded ?? this.paramSetsCanBeAdded,
      selectedParamSetCanBeRemoved:
          selectedParamSetCanBeRemoved ?? this.selectedParamSetCanBeRemoved,
      paramSetsCanBeRemovedInBulk:
          paramSetsCanBeRemovedInBulk ?? this.paramSetsCanBeRemovedInBulk,
    );
  }

  @override
  List<Object?> get props => [
        paramSetValues,
        selectedIndex,
        paramSetsCanBeAdded,
        selectedParamSetCanBeRemoved,
        paramSetsCanBeRemovedInBulk,
      ];

  Map<String, dynamic> toJson() {
    return {
      "paramSetValues": paramSetValues.map((item) => item.toJson()).toList(),
      "selectedIndex": selectedIndex,
      "paramSetsCanBeAdded": paramSetsCanBeAdded,
      "paramSetCanBeRemoved": selectedParamSetCanBeRemoved,
      "paramSetsCanBeRemovedInBulk": paramSetsCanBeRemovedInBulk,
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
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetValueBulkModel{'
        'paramSetValues: $paramSetValues, '
        'selectedIndex: $selectedIndex, '
        'paramSetsCanBeAdded: $paramSetsCanBeAdded, '
        'paramSetCanBeRemoved: $selectedParamSetCanBeRemoved, '
        'paramSetsCanBeRemovedInBulk: $paramSetsCanBeRemovedInBulk}';
  }
}
