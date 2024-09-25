import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';

class EditUnitCodeUseCase extends ModifyUnitDetailsUseCase<String> {
  const EditUnitCodeUseCase();

  @override
  String getDraftUnitCode(InputUnitDetailsModifyModel<String> input) {
    return input.delta;
  }

  @override
  String getErrorMessage() {
    return "Error when editing unit code in unit details";
  }
}
