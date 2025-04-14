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

  const ConversionParamSetValueBulkModel({
    this.paramSetValues = const [],
    this.selectedIndex = 0,
  });

  @override
  List<Object?> get props => [
        paramSetValues,
        selectedIndex,
      ];

  bool get hasMandatoryParamSet {
    return paramSetValues.any((e) => e.paramSet.mandatory);
  }

  Map<String, dynamic> toJson() {
    return {
      "paramSetValues": paramSetValues.map((item) => item.toJson()).toList(),
      "selectedIndex": selectedIndex,
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
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetValueBulkModel{'
        'paramSetValues: $paramSetValues, '
        'selectedIndex: $selectedIndex}';
  }
}
