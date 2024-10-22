import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModel {
  final UnitGroupModel unitGroup;
  final ConversionItemModel sourceConversionItem;
  final List<UnitModel> targetUnits;

  const InputConversionModel({
    required this.unitGroup,
    required this.sourceConversionItem,
    this.targetUnits = const [],
  });

  @override
  String toString() {
    return 'InputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetUnits: $targetUnits}';
  }
}

