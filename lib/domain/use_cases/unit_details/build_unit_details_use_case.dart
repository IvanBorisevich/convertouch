import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/unit_details_utils.dart';
import 'package:either_dart/either.dart';

class BuildUnitDetailsUseCase
    extends UseCase<InputUnitDetailsBuildModel, OutputUnitDetailsModel> {
  final UnitRepository unitRepository;

  const BuildUnitDetailsUseCase({
    required this.unitRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputUnitDetailsModel>> execute(
    InputUnitDetailsBuildModel input,
  ) async {
    try {
      UnitModel unit = getUnit(input);

      UnitModel baseUnit = await getBaseUnit(
        unit: unit,
        unitGroup: input.unitGroup,
      );

      ValueModel argValue = getArgValue(
        argUnit: baseUnit,
        unit: unit,
      );

      bool editMode = !unit.oob;
      bool conversionConfigEditable = editMode && baseUnit.exists;

      UnitDetailsModel resultDetails = UnitDetailsModel(
        unitGroup: input.unitGroup,
        unitData: UnitModel(
          id: unit.id,
          name: unit.name,
          code: unit.code,
          symbol: unit.symbol,
          valueType: unit.valueType ?? input.unitGroup.valueType,
          minValue: unit.minValue ?? input.unitGroup.minValue,
          maxValue: unit.maxValue ?? input.unitGroup.maxValue,
        ),
        value: ValueModel.one,
        argUnit: baseUnit,
        argValue: argValue,
      );

      return Right(
        OutputUnitDetailsModel(
          draft: resultDetails,
          saved: resultDetails,
          unitToSave: null,
          editMode: editMode,
          conversionConfigEditable: conversionConfigEditable,
          conversionDescription: UnitDetailsUtils.getConversionDesc(
            unitGroup: input.unitGroup,
            unitData: unit,
            argUnit: baseUnit,
            argValue: argValue,
          ),
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when building unit details",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  UnitModel getUnit(InputUnitDetailsBuildModel input) {
    bool existingUnit = input is InputExistingUnitDetailsBuildModel;
    return existingUnit ? input.unit : UnitModel.none;
  }

  Future<UnitModel> getBaseUnit({
    required UnitModel unit,
    required UnitGroupModel unitGroup,
  }) async {
    List<UnitModel> baseUnits = ObjectUtils.tryGet(
      await unitRepository.getBaseUnits(unitGroup.id!),
    );

    UnitModel? firstBaseUnit = baseUnits.firstOrNull;
    UnitModel? secondBaseUnit = baseUnits.length > 1 ? baseUnits.last : null;
    UnitModel argUnit;

    if (unit.exists) {
      if (firstBaseUnit != null && unit.id! != firstBaseUnit.id) {
        argUnit = firstBaseUnit;
      } else if (secondBaseUnit != null && unit.id! != secondBaseUnit.id) {
        argUnit = secondBaseUnit;
      } else {
        argUnit = UnitModel.none;
      }
    } else {
      argUnit = firstBaseUnit ?? UnitModel.none;
    }

    return argUnit;
  }

  ValueModel getArgValue({
    required UnitModel argUnit,
    required UnitModel unit,
  }) {
    return argUnit.exists
        ? UnitDetailsUtils.calcNewArgValue(
            unitCoefficient: unit.coefficient,
            argUnitCoefficient: argUnit.coefficient!,
          )
        : ValueModel.none;
  }
}
