import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class OutputConversionModel {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> targetConversionItems;

  const OutputConversionModel({
    this.unitGroup,
    this.sourceConversionItem,
    this.targetConversionItems = const [],
  });

  @override
  String toString() {
    return 'OutputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetConversionItems: $targetConversionItems}';
  }
}