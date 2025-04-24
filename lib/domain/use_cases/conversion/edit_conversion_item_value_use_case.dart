import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  const EditConversionItemValueUseCase({
    required super.createConversionUseCase,
  });

  @override
  ConversionUnitValueModel modifySourceUnitValue({
    required ConversionUnitValueModel? currentSourceItem,
    required Map<int, ConversionUnitValueModel> modifiedConversionItemsMap,
    required EditConversionItemValueDelta delta,
  }) {
    ConversionUnitValueModel currentSrcItem =
        modifiedConversionItemsMap[delta.unitId]!;

    return ConversionUnitValueModel.wrap(
      unit: currentSrcItem.unit,
      value: delta.newValue,
      defaultValue: delta.newDefaultValue,
    );
  }
}
