import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class ConversionModel extends IdNameItemModel {
  static const none = ConversionModel.noItems(UnitGroupModel.none);

  final UnitGroupModel unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> targetConversionItems;

  const ConversionModel({
    super.id = -1,
    super.name = "",
    this.unitGroup = UnitGroupModel.none,
    this.sourceConversionItem,
    this.targetConversionItems = const [],
  }) : super(
          itemType: ItemType.conversion,
        );

  const ConversionModel.noItems(UnitGroupModel unitGroup)
      : this(
          unitGroup: unitGroup,
        );

  ConversionModel.coalesce(
    ConversionModel saved, {
    int? id,
    String? name,
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          unitGroup: saved.unitGroup,
          sourceConversionItem: saved.sourceConversionItem,
          targetConversionItems: saved.targetConversionItems,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "unitGroup": unitGroup.toJson(),
      "sourceItem": sourceConversionItem?.toJson(),
      "targetItems":
          targetConversionItems.map((item) => item.toJson()).toList(),
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
      sourceConversionItem: ConversionItemModel.fromJson(json["sourceItem"]),
      targetConversionItems: (json["targetItems"] as List)
          .map((unitMap) => ConversionItemModel.fromJson(unitMap)!)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        unitGroup,
        sourceConversionItem,
        targetConversionItems,
      ];

  bool get exists => this != none;

  @override
  String toString() {
    return 'ConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetConversionItems: $targetConversionItems}';
  }
}
