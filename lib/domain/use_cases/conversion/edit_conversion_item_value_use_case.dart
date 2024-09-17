import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
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
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    EditConversionItemValueDelta delta,
  ) {
    return unitGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    EditConversionItemValueDelta delta,
  ) {
    return ConversionItemModel.coalesce(
      sourceItem,
      value: delta.newValue != null
          ? ValueModel.ofString(delta.newValue)
          : sourceItem?.value,
      defaultValue: delta.newDefaultValue != null
          ? ValueModel.ofString(delta.newDefaultValue)
          : ValueModel.one,
    );
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    EditConversionItemValueDelta delta,
  ) {
    return targetUnits;
  }
}
