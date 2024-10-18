import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class ConversionModel extends Equatable {
  static const none = ConversionModel.noItems(UnitGroupModel.none);

  final UnitGroupModel unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> targetConversionItems;

  const ConversionModel({
    this.unitGroup = UnitGroupModel.none,
    this.sourceConversionItem,
    this.targetConversionItems = const [],
  });

  const ConversionModel.noItems(this.unitGroup)
      : sourceConversionItem = null,
        targetConversionItems = const [];

  Map<String, dynamic> toJson() {
    return {
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
        unitGroup,
        sourceConversionItem,
        targetConversionItems,
      ];

  @override
  String toString() {
    return 'OutputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetConversionItems: $targetConversionItems}';
  }
}
