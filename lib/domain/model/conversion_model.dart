import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class ConversionModel extends IdNameItemModel {
  static const none = ConversionModel.noItems(
    id: -1,
    unitGroup: UnitGroupModel.none,
    params: null,
  );

  final UnitGroupModel unitGroup;
  final ConversionUnitValueModel? sourceConversionItem;
  final ConversionParamSetValueBulkModel? params;
  final List<ConversionUnitValueModel> conversionUnitValues;

  const ConversionModel({
    super.id = -1,
    super.name = "",
    this.unitGroup = UnitGroupModel.none,
    this.sourceConversionItem,
    this.params,
    this.conversionUnitValues = const [],
  }) : super(
          itemType: ItemType.conversion,
        );

  const ConversionModel.noItems({
    required int id,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueBulkModel? params,
  }) : this(
          id: id,
          unitGroup: unitGroup,
          params: params,
        );

  ConversionModel.coalesce(
    ConversionModel saved, {
    int? id,
    String? name,
    UnitGroupModel? unitGroup,
    ConversionUnitValueModel? sourceConversionItem,
    List<ConversionUnitValueModel>? targetConversionItems,
    ConversionParamSetValueBulkModel? params,
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          unitGroup: unitGroup ?? saved.unitGroup,
          sourceConversionItem:
              sourceConversionItem ?? saved.sourceConversionItem,
          conversionUnitValues:
              targetConversionItems ?? saved.conversionUnitValues,
          params: params ?? saved.params,
        );

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "id": id,
      "unitGroup": unitGroup.toJson(),
      "sourceItem": sourceConversionItem?.toJson(),
      "params": params?.toJson(),
      "targetItems": conversionUnitValues.map((item) => item.toJson()).toList(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ConversionModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionModel(
      id: json["id"] ?? -1,
      unitGroup:
          UnitGroupModel.fromJson(json["unitGroup"]) ?? UnitGroupModel.none,
      sourceConversionItem:
          ConversionUnitValueModel.fromJson(json["sourceItem"]),
      params: ConversionParamSetValueBulkModel.fromJson(json["params"]),
      conversionUnitValues: (json["targetItems"] as List)
          .map((unitMap) => ConversionUnitValueModel.fromJson(unitMap)!)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        unitGroup,
        sourceConversionItem,
        params,
        conversionUnitValues,
      ];

  bool get exists => this != none;

  @override
  String toString() {
    return 'ConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'params: $params, '
        'targetConversionItems: $conversionUnitValues}';
  }
}
