import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class ConversionModel extends IdNameItemModel {
  static const none = ConversionModel.noItems(
    id: -1,
    unitGroup: UnitGroupModel.none,
  );

  final UnitGroupModel unitGroup;
  final ConversionUnitValueModel? sourceConversionItem;
  final List<ConversionParamSetValuesModel> conversionParamSetValues;
  final List<ConversionUnitValueModel> conversionUnitValues;

  const ConversionModel({
    super.id = -1,
    super.name = "",
    this.unitGroup = UnitGroupModel.none,
    this.sourceConversionItem,
    this.conversionParamSetValues = const [],
    this.conversionUnitValues = const [],
  }) : super(
          itemType: ItemType.conversion,
        );

  const ConversionModel.noItems({
    required int id,
    required UnitGroupModel unitGroup,
  }) : this(
          id: id,
          unitGroup: unitGroup,
        );

  ConversionModel.coalesce(
    ConversionModel saved, {
    int? id,
    String? name,
    UnitGroupModel? unitGroup,
    ConversionUnitValueModel? sourceConversionItem,
    List<ConversionUnitValueModel>? targetConversionItems,
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          unitGroup: unitGroup ?? saved.unitGroup,
          sourceConversionItem:
              sourceConversionItem ?? saved.sourceConversionItem,
          conversionUnitValues:
              targetConversionItems ?? saved.conversionUnitValues,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "unitGroup": unitGroup.toJson(),
      "sourceItem": sourceConversionItem?.toJson(),
      "params":
          conversionParamSetValues.map((param) => param.toJson()).toList(),
      "targetItems": conversionUnitValues.map((item) => item.toJson()).toList(),
    };
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
      conversionParamSetValues: (json["params"] as List)
          .map((paramsSetMap) =>
              ConversionParamSetValuesModel.fromJson(paramsSetMap)!)
          .toList(),
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
        conversionParamSetValues,
        conversionUnitValues,
      ];

  bool get exists => this != none;

  @override
  String toString() {
    return 'ConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'conversionParamSetValues: $conversionParamSetValues, '
        'targetConversionItems: $conversionUnitValues}';
  }
}
