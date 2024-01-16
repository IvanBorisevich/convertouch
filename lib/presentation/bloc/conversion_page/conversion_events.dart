import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/usecases/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  const ConversionEvent();
}

class BuildConversion extends ConversionEvent {
  final InputConversionModel conversionParams;

  const BuildConversion({
    required this.conversionParams,
  });

  @override
  List<Object?> get props => [
        conversionParams,
      ];

  @override
  String toString() {
    return 'BuildConversion{'
        'conversionParams: $conversionParams}';
  }
}

class RemoveConversionItem extends ConversionEvent {
  final UnitGroupModel? unitGroupInConversion;
  final int itemUnitId;
  final List<ConversionItemModel> conversionItems;

  const RemoveConversionItem({
    required this.unitGroupInConversion,
    required this.itemUnitId,
    required this.conversionItems,
  });

  @override
  List<Object?> get props => [
        unitGroupInConversion,
        itemUnitId,
        conversionItems,
      ];

  @override
  String toString() {
    return 'RemoveConversionItem{'
        'unitGroupInConversion: $unitGroupInConversion, '
        'itemUnitId: $itemUnitId, '
        'conversionItems: $conversionItems}';
  }
}

class RestoreLastConversion extends ConversionEvent {
  const RestoreLastConversion();

  @override
  String toString() {
    return 'RestoreLastConversion{}';
  }
}
