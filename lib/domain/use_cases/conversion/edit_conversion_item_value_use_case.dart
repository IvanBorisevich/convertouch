import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  const EditConversionItemValueUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  ConversionItemModel? modifySourceConversionItem({
    required ConversionItemModel? sourceItem,
    required Map<int, UnitModel> targetUnits,
    required EditConversionItemValueDelta delta,
  }) {
    ValueModel? newValue = delta.newValue != null
        ? ValueModel.ofString(delta.newValue)
        : sourceItem?.value;

    ValueModel? newDefaultValue = delta.newDefaultValue != null
        ? ValueModel.ofString(delta.newDefaultValue)
        : ValueModel.one;

    if (delta.unitId == sourceItem?.unit.id) {
      return ConversionItemModel.coalesce(
        sourceItem,
        value: newValue,
        defaultValue: newDefaultValue,
      );
    } else {
      return ConversionItemModel(
        unit: targetUnits[delta.unitId]!,
        value: newValue ?? ValueModel.none,
        defaultValue: newDefaultValue,
      );
    }
  }
}
