import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  const EditConversionItemValueUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  ConversionItemModel getModifiedSourceItem({
    required ConversionItemModel? currentSourceItem,
    required Map<int, ConversionItemModel> modifiedConversionItemsMap,
    required EditConversionItemValueDelta delta,
  }) {
    ValueModel? newValue = delta.newValue != null
        ? ValueModel.ofString(delta.newValue)
        : currentSourceItem?.value;

    ValueModel? newDefaultValue = delta.newDefaultValue != null
        ? ValueModel.ofString(delta.newDefaultValue)
        : ValueModel.one;

    return ConversionItemModel.coalesce(
      modifiedConversionItemsMap[delta.unitId]!,
      value: newValue ?? ValueModel.none,
      defaultValue: newDefaultValue,
    );
  }
}
