import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionGroupUseCase
    extends AbstractModifyConversionUseCase<EditConversionGroupDelta> {
  const EditConversionGroupUseCase();

  @override
  UnitGroupModel newGroup({
    required UnitGroupModel oldGroup,
    required EditConversionGroupDelta delta,
  }) {
    return delta.editedGroup;
  }
}
