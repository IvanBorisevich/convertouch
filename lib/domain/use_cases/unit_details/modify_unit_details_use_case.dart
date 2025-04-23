import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/model/conversion_rule_form_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/unit_details_utils.dart';
import 'package:either_dart/either.dart';

class ModifyUnitDetailsUseCase
    extends UseCase<UnitDetailsModel, UnitDetailsModel> {
  final UnitRepository unitRepository;

  const ModifyUnitDetailsUseCase({
    required this.unitRepository,
  });

  @override
  Future<Either<ConvertouchException, UnitDetailsModel>> execute(
    UnitDetailsModel input,
  ) async {
    try {
      bool existingUnit = input.savedUnitData.hasId;
      final unitGroupChanged =
          input.unitGroup.id != input.draftUnitData.unitGroupId;

      UnitModel primaryBaseUnit;
      UnitModel secondaryBaseUnit;
      UnitModel argUnit;
      ValueModel savedArgValue;

      if (unitGroupChanged) {
        List<UnitModel> baseUnits = ObjectUtils.tryGet(
          await unitRepository.getBaseUnits(input.unitGroup.id),
        );

        primaryBaseUnit = UnitDetailsUtils.getPrimaryBaseUnit(
          baseUnits: baseUnits,
          draftUnitId: input.draftUnitData.id,
        );

        secondaryBaseUnit = UnitDetailsUtils.getSecondaryBaseUnit(
          baseUnits: baseUnits,
          primaryBaseUnitId: primaryBaseUnit.id,
        );

        argUnit = primaryBaseUnit;

        savedArgValue = UnitDetailsUtils.getArgValue(
          argUnit: primaryBaseUnit,
          unit: input.draftUnitData,
        );
      } else {
        primaryBaseUnit = input.conversionRule.primaryBaseUnit;
        secondaryBaseUnit = input.conversionRule.secondaryBaseUnit;
        argUnit = input.conversionRule.argUnit;
        savedArgValue = input.conversionRule.draftArgValue;
      }

      final resultUnitName = ObjectUtils.coalesceStringOrDefault(
        str1: input.draftUnitData.name,
        str2: input.savedUnitData.name,
      );

      final savedUnitCode = existingUnit
          ? input.savedUnitData.code
          : UnitDetailsUtils.calcInitialUnitCode(input.draftUnitData.name);

      final resultUnitCode = ObjectUtils.coalesceStringOrDefault(
        str1: input.draftUnitData.code,
        str2: savedUnitCode,
      );

      final resultUnitSymbol = ObjectUtils.coalesceStringOrNull(
        str1: input.draftUnitData.symbol,
        str2: input.savedUnitData.symbol,
      );

      final draftCoefficient = UnitDetailsUtils.calcUnitCoefficient(
        value: input.conversionRule.unitValue,
        argUnit: input.conversionRule.argUnit,
        argValue: input.conversionRule.draftArgValue,
      );

      final mandatoryParamsFilled =
          StringUtils.isNotNullOrEmpty(resultUnitName) &&
              StringUtils.isNotNullOrEmpty(resultUnitCode);
      final unitNameChanged = resultUnitName != input.savedUnitData.name;
      final unitCodeChanged = resultUnitCode != savedUnitCode;
      final unitSymbolChanged = resultUnitSymbol != input.savedUnitData.symbol;
      final coefficientChanged = DoubleValueUtils.areNotEqual(
        draftCoefficient,
        input.savedUnitData.coefficient,
      );

      final deltaDetected = mandatoryParamsFilled &&
          (unitGroupChanged ||
              unitNameChanged ||
              unitCodeChanged ||
              unitSymbolChanged ||
              coefficientChanged);

      final resultUnit = UnitModel(
        id: input.savedUnitData.id,
        name: resultUnitName,
        code: resultUnitCode,
        symbol: resultUnitSymbol,
        valueType: input.draftUnitData.valueType,
        coefficient: draftCoefficient,
        unitGroupId: input.unitGroup.id,
      );

      return Right(
        UnitDetailsModel(
          unitGroup: input.unitGroup,
          draftUnitData: input.draftUnitData,
          savedUnitData: input.savedUnitData.copyWith(
            code: savedUnitCode,
          ),
          existingUnit: existingUnit,
          editMode: true,
          unitGroupChanged: unitGroupChanged,
          deltaDetected: deltaDetected,
          resultUnit: resultUnit,
          conversionRule: ConversionRuleFormModel.build(
            unitGroup: input.unitGroup,
            mandatoryParamsFilled: mandatoryParamsFilled,
            draftUnit: input.draftUnitData,
            draftUnitValue: input.conversionRule.unitValue,
            argUnit: argUnit,
            draftArgValue: input.conversionRule.draftArgValue,
            savedArgValue: savedArgValue,
            primaryBaseUnit: primaryBaseUnit,
            secondaryBaseUnit: secondaryBaseUnit,
          ),
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when modifying unit details",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
