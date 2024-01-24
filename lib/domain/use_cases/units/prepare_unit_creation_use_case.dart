import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_preparation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_preparation_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class PrepareUnitCreationUseCase
    extends UseCase<InputUnitPreparationModel, OutputUnitPreparationModel> {
  static const String _firstUnitNote = "It's a first unit being added. "
      "Its coefficient will be set as 1 by default.";

  final UnitRepository unitRepository;

  const PrepareUnitCreationUseCase(this.unitRepository);

  @override
  Future<Either<Failure, OutputUnitPreparationModel>> execute(
    InputUnitPreparationModel input,
  ) async {
    try {
      UnitModel? baseUnit;
      UnitGroupModel? unitGroup = input.unitGroup;
      String? comment;

      if (unitGroup != null) {
        UnitModel? baseUnit = input.baseUnit ??
            ObjectUtils.tryGet(await unitRepository.getBaseUnit(unitGroup.id!));
        comment = baseUnit == null ? _firstUnitNote : null;
      }

      return Right(
        OutputUnitPreparationModel(
          baseUnit: baseUnit,
          unitGroup: unitGroup,
          comment: comment,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when preparing unit for creation: $e"),
      );
    }
  }
}
