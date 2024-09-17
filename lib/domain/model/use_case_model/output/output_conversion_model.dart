import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class OutputConversionModel extends Equatable {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> targetConversionItems;

  const OutputConversionModel({
    this.unitGroup,
    this.sourceConversionItem,
    this.targetConversionItems = const [],
  });

  const OutputConversionModel.none()
      : unitGroup = null,
        sourceConversionItem = null,
        targetConversionItems = const [];

  const OutputConversionModel.noItems(this.unitGroup)
      : sourceConversionItem = null,
        targetConversionItems = const [];

  Map<String, dynamic> toJson() {
    return {
      "unitGroup": unitGroup?.toJson(),
      "sourceItem": sourceConversionItem?.toJson(),
      "targetItems":
          targetConversionItems.map((item) => item.toJson()).toList(),
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
