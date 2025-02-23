import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class RemoveConversionItemsUseCase
    extends AbstractModifyConversionUseCase<RemoveConversionItemsDelta> {
  const RemoveConversionItemsUseCase({
    required super.createConversionUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> modifyConversionItems({
    required Map<int, ConversionUnitValueModel> conversionItemsMap,
    required RemoveConversionItemsDelta delta,
  }) async {
    conversionItemsMap.removeWhere(
      (unitId, item) => delta.unitIds.contains(unitId),
    );
    return conversionItemsMap;
  }

  @override
  ConversionUnitValueModel getModifiedSourceItem({
    required ConversionUnitValueModel? currentSourceItem,
    required Map<int, ConversionUnitValueModel> modifiedConversionItemsMap,
    required RemoveConversionItemsDelta delta,
  }) {
    if (currentSourceItem != null &&
        !delta.unitIds.contains(currentSourceItem.unit.id)) {
      return modifiedConversionItemsMap[currentSourceItem.unit.id]!;
    }
    return modifiedConversionItemsMap.values.first;
  }
}
