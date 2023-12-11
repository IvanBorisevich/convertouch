import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/unit_creation_events.dart';
import 'package:convertouch/domain/model/output/unit_creation_states.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class PrepareUnitCreationUseCase
    extends UseCase<PrepareUnitCreation, UnitCreationPrepared> {
  static const String _firstUnitNote = "It's a first unit being added. "
      "Its coefficient will be set as 1 by default.";

  final UnitRepository unitRepository;

  const PrepareUnitCreationUseCase(this.unitRepository);

  @override
  Future<Either<Failure, UnitCreationPrepared>> execute({
    required PrepareUnitCreation input,
  }) async {
    try {
      UnitModel? baseUnit;
      UnitGroupModel? unitGroup = input.unitGroup;
      String? comment;

      if (unitGroup != null) {
        var defaultBaseUnitResult =
            await unitRepository.getDefaultBaseUnit(unitGroup.id!);

        if (defaultBaseUnitResult.isLeft) {
          throw defaultBaseUnitResult.left;
        }

        UnitModel? defaultBaseUnit = defaultBaseUnitResult.right;
        baseUnit = input.baseUnit ?? defaultBaseUnit;
        comment = baseUnit == null ? _firstUnitNote : null;
      }

      return Right(
        UnitCreationPrepared(
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
