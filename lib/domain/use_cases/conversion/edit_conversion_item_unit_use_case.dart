import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemUnitDelta> {
  const EditConversionItemUnitUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  Future<Map<int, ConversionItemModel>> modifyConversionItems({
    required Map<int, ConversionItemModel> conversionItemsMap,
    required EditConversionItemUnitDelta delta,
  }) async {
    if (conversionItemsMap.containsKey(delta.editedUnit.id)) {
      conversionItemsMap.update(
        delta.editedUnit.id,
        (value) => ConversionItemModel.coalesce(
          value,
          unit: delta.editedUnit,
        ),
      );
    }
    return conversionItemsMap;
  }
}
