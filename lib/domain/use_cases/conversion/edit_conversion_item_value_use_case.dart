import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  const EditConversionItemValueUseCase({
    required super.createConversionUseCase,
  });

  @override
  ConversionUnitValueModel modifySourceItem({
    required ConversionUnitValueModel? currentSourceItem,
    required Map<int, ConversionUnitValueModel> modifiedConversionItemsMap,
    required EditConversionItemValueDelta delta,
  }) {
    ValueModel? newValue = delta.newValue != null
        ? ValueModel.str(delta.newValue)
        : currentSourceItem?.value;

    ValueModel? newDefaultValue = delta.newDefaultValue != null
        ? ValueModel.str(delta.newDefaultValue)
        : ValueModel.one;

    return ConversionUnitValueModel.coalesce(
      modifiedConversionItemsMap[delta.unitId]!,
      value: newValue ?? ValueModel.empty,
      defaultValue: newDefaultValue,
    );
  }
}
