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

  @override
  String toString() {
    return 'OutputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetConversionItems: $targetConversionItems}';
  }

  @override
  List<Object?> get props => [
    unitGroup,
    sourceConversionItem,
    targetConversionItems,
    emptyConversionItemsExist,
  ];
}