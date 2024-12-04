import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class RemoveConversionItemsUseCase
    extends AbstractModifyConversionUseCase<RemoveConversionItemsDelta> {
  const RemoveConversionItemsUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  Future<Map<int, ConversionItemModel>> modifyConversionItems({
    required Map<int, ConversionItemModel> conversionItemsMap,
    required RemoveConversionItemsDelta delta,
  }) async {
    conversionItemsMap.removeWhere(
      (unitId, item) => delta.unitIds.contains(unitId),
    );
    return conversionItemsMap;
  }

  @override
  ConversionItemModel getModifiedSourceItem({
    required ConversionItemModel? currentSourceItem,
    required Map<int, ConversionItemModel> modifiedConversionItemsMap,
    required RemoveConversionItemsDelta delta,
  }) {
    if (currentSourceItem != null &&
        !delta.unitIds.contains(currentSourceItem.unit.id)) {
      return modifiedConversionItemsMap[currentSourceItem.unit.id]!;
    }
    return modifiedConversionItemsMap.values.first;
  }
}
