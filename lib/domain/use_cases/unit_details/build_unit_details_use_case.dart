import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/model/conversion_rule_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/unit_details_utils.dart';
import 'package:either_dart/either.dart';

class BuildUnitDetailsUseCase
    extends UseCase<InputUnitDetailsBuildModel, UnitDetailsModel> {
  final UnitRepository unitRepository;

  const BuildUnitDetailsUseCase({
    required this.unitRepository,
  });

  @override
  Future<Either<ConvertouchException, UnitDetailsModel>> execute(
    InputUnitDetailsBuildModel input,
  ) async {
    try {
      UnitModel unit = getUnit(input);

      List<UnitModel> baseUnits = ObjectUtils.tryGet(
        await unitRepository.getBaseUnits(input.unitGroup.id),
      );

      UnitModel primaryBaseUnit = UnitDetailsUtils.getPrimaryBaseUnit(
        baseUnits: baseUnits,
        draftUnitId: unit.id,
      );

      UnitModel secondaryBaseUnit = UnitDetailsUtils.getSecondaryBaseUnit(
        baseUnits: baseUnits,
        primaryBaseUnitId: primaryBaseUnit.id,
      );

      ValueModel argValue = UnitDetailsUtils.getArgValue(
        argUnit: primaryBaseUnit,
        unit: unit,
      );

      if (!unit.hasId) {
        final coefficient = UnitDetailsUtils.calcUnitCoefficient(
          value: ValueModel.one,
          argUnit: primaryBaseUnit,
          argValue: argValue,
        );

        unit = UnitModel.coalesce(
          unit,
          coefficient: coefficient,
        );
      }

      bool mandatoryParamsFilled = StringUtils.isNotNullOrEmpty(unit.name) &&
          StringUtils.isNotNullOrEmpty(unit.code);

      return Right(
        UnitDetailsModel(
          editMode: !unit.oob,
          unitGroup: input.unitGroup,
          draftUnitData: unit,
          savedUnitData: unit,
          unitGroupChanged: false,
          unitToSave: UnitModel.none,
          conversionRule: ConversionRule.build(
            unitGroup: input.unitGroup,
            mandatoryParamsFilled: mandatoryParamsFilled,
            draftUnit: unit,
            draftUnitValue: ValueModel.one,
            argUnit: primaryBaseUnit,
            draftArgValue: argValue,
            savedArgValue: argValue,
            primaryBaseUnit: primaryBaseUnit,
            secondaryBaseUnit: secondaryBaseUnit,
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

    return existingUnit
        ? UnitModel.coalesce(
            input.unit,
            valueType: input.unit.valueType ?? input.unitGroup.valueType,
            minValue: input.unit.minValue ?? input.unitGroup.minValue,
            maxValue: input.unit.maxValue ?? input.unitGroup.maxValue,
          )
        : UnitModel(
            name: "",
            code: "",
            unitGroupId: input.unitGroup.id,
            valueType: input.unitGroup.valueType,
            minValue: input.unitGroup.minValue,
            maxValue: input.unitGroup.maxValue,
          );
  }
}
