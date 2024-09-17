import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class UpdateConversionCoefficientsUseCase
    extends AbstractModifyConversionUseCase<UpdateConversionCoefficientsDelta> {
  const UpdateConversionCoefficientsUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    UpdateConversionCoefficientsDelta delta,
  ) {
    return unitGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    UpdateConversionCoefficientsDelta delta,
  ) {
    if (delta.updatedUnitCoefs.containsKey(sourceItem?.unit.code)) {
      return ConversionItemModel.coalesce(
        sourceItem,
        unit: UnitModel.coalesce(
          sourceItem!.unit,
          coefficient: delta.updatedUnitCoefs[sourceItem.unit.code],
        ),
      );
    } else {
      return sourceItem;
    }
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    UpdateConversionCoefficientsDelta delta,
  ) {
    targetUnits.updateAll(
      (key, value) => UnitModel.coalesce(
        value,
        coefficient: delta.updatedUnitCoefs[value.code],
      ),
    );
    return targetUnits;
  }
}
