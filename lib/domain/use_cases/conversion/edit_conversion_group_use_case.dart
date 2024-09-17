import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionGroupUseCase
    extends AbstractModifyConversionUseCase<EditConversionGroupDelta> {
  const EditConversionGroupUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    EditConversionGroupDelta delta,
  ) {
    return delta.editedGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    EditConversionGroupDelta delta,
  ) {
    return sourceItem;
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    EditConversionGroupDelta delta,
  ) {
    return targetUnits;
  }
}
