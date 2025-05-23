import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemUnitDelta> {
  const EditConversionItemUnitUseCase();

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required EditConversionItemUnitDelta delta,
  }) async {
    if (oldConvertedUnitValues.containsKey(delta.editedUnit.id)) {
      oldConvertedUnitValues.update(
        delta.editedUnit.id,
        (value) => value.copyWith(unit: delta.editedUnit),
      );
    }
    return oldConvertedUnitValues;
  }
}
