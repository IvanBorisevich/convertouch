import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';

class ChangeArgUnitUseCase extends ModifyUnitDetailsUseCase<UnitModel> {
  const ChangeArgUnitUseCase();

  @override
  Future<UnitModel> getDraftArgUnit(
    InputUnitDetailsModifyModel<UnitModel> input,
  ) async {
    return input.delta;
  }

  @override
  String getErrorMessage() {
    return "Error when changing arg unit in unit details";
  }
}
