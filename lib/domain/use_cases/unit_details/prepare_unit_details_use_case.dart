import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

abstract class PrepareUnitDetailsUseCase
    extends UseCase<UnitDetailsModel, UnitDetailsModel> {
  final UnitRepository unitRepository;

  const PrepareUnitDetailsUseCase({
    required this.unitRepository,
  });

  Future<UnitModel> calculateArgUnit(UnitDetailsModel unitDetails) async {
    if (unitDetails.unitGroup != null) {
      return ObjectUtils.tryGet(
        await unitRepository.getBaseUnit(unitDetails.unitGroup!.id!),
      );
    }
    return UnitModel.none;
  }

  Future<ValueModel> calculateArgValue({
    required double currentUnitCoefficient,
    required ValueModel currentValue,
    required double argUnitCoefficient,
  }) async {
    double unitValue = double.tryParse(currentValue.strValue) ?? 1;
    double argUnitValue =
        currentUnitCoefficient / argUnitCoefficient * unitValue;
    return ValueModel.ofDouble(argUnitValue);
  }
}
