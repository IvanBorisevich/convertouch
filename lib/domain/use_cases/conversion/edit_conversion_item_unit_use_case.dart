import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemUnitDelta> {
  const EditConversionItemUnitUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    EditConversionItemUnitDelta delta,
  ) {
    return unitGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    EditConversionItemUnitDelta delta,
  ) {
    if (delta.editedUnit.id == sourceItem?.unit.id) {
      return ConversionItemModel.coalesce(
        sourceItem,
        unit: delta.editedUnit,
      );
    }
    return sourceItem;
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    EditConversionItemUnitDelta delta,
  ) {
    if (targetUnits[delta.editedUnit.id] != null) {
      targetUnits[delta.editedUnit.id] = delta.editedUnit;
    }
    return targetUnits;
  }
}
