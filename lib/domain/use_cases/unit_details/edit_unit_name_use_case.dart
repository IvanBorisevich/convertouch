import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';

class EditUnitNameUseCase extends ModifyUnitDetailsUseCase<String> {
  const EditUnitNameUseCase();

  @override
  String getDraftUnitName(InputUnitDetailsModifyModel<String> input) {
    return input.delta;
  }

  @override
  String getErrorMessage() {
    return "Error when editing unit name in unit details";
  }
}
