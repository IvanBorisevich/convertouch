import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';

class EditUnitValueUseCase extends ModifyUnitDetailsUseCase<String> {
  const EditUnitValueUseCase();

  @override
  ValueModel getDraftUnitValue(InputUnitDetailsModifyModel<String> input) {
    return ValueModel.ofString(input.delta);
  }

  @override
  String getErrorMessage() {
    return "Error when editing unit value in unit details";
  }
}
