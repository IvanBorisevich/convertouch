import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class PrepareUnitDetailsUseCase
    extends UseCase<UnitDetailsModel, UnitDetailsModel> {
  final UnitRepository unitRepository;

  const PrepareUnitDetailsUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, UnitDetailsModel>> execute(
    UnitDetailsModel input,
  ) async {
    try {
      UnitModel? argumentUnit;
      UnitGroupModel? unitGroup = input.unitGroup;

      if (unitGroup != null) {
        argumentUnit = input.argumentUnit ??
            ObjectUtils.tryGet(
              await unitRepository.getBaseUnit(unitGroup.id!),
            );
      }

      return Right(
        UnitDetailsModel(
          unitGroup: unitGroup,
          unitName: input.unitName,
          unitCode: input.unitCode,
          unitValue: input.unitValue,
          argumentUnit: argumentUnit,
          argumentUnitValue: input.argumentUnitValue,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when preparing unit details: $e",
        ),
      );
    }
  }
}
