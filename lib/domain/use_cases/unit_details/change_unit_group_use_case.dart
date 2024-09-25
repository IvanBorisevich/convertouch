import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ChangeUnitGroupUseCase extends ModifyUnitDetailsUseCase<UnitGroupModel> {
  final UnitRepository unitRepository;

  const ChangeUnitGroupUseCase({
    required this.unitRepository,
  });

  @override
  UnitGroupModel getDraftUnitGroup(
    InputUnitDetailsModifyModel<UnitGroupModel> input,
  ) {
    return input.delta;
  }

  @override
  Future<UnitModel> getDraftArgUnit(
    InputUnitDetailsModifyModel<UnitGroupModel> input,
  ) async {
    List<UnitModel> baseUnits = ObjectUtils.tryGet(
      await unitRepository.getBaseUnits(input.delta.id!),
    );
    return baseUnits.firstOrNull ?? UnitModel.none;
  }

  @override
  String getErrorMessage() {
    return "Error when changing unit group in unit details";
  }
}
