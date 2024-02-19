import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class OutputConversionModel extends Equatable {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> targetConversionItems;
  final bool emptyConversionItemsExist;

  const OutputConversionModel({
    this.unitGroup,
    this.sourceConversionItem,
    this.targetConversionItems = const [],
    this.emptyConversionItemsExist = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "unitGroup": unitGroup?.toJson(),
      "sourceItem": sourceConversionItem?.toJson(),
      "targetItems":
          targetConversionItems.map((item) => item.toJson()).toList(),
      "emptyConversionItemsExist": emptyConversionItemsExist,
    };
  }

  static OutputConversionModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return OutputConversionModel(
      unitGroup: UnitGroupModel.fromJson(json["unitGroup"]),
      sourceConversionItem: ConversionItemModel.fromJson(json["sourceItem"]),
      targetConversionItems: (json["targetItems"] as List)
          .map((unitMap) => ConversionItemModel.fromJson(unitMap)!)
          .toList(),
      emptyConversionItemsExist: json["emptyConversionItemsExist"],
    );
  }

  @override
  List<Object?> get props => [
        unitGroup,
        sourceConversionItem,
        targetConversionItems,
        emptyConversionItemsExist,
      ];

  @override
  String toString() {
    return 'OutputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetConversionItems: $targetConversionItems}';
  }
}
