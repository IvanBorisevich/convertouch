import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
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

      List<UnitModel> baseUnits = ObjectUtils.tryGet(
        await unitRepository.getBaseUnits(input.unitGroup.id),
      );

      UnitModel firstBaseUnit = getFirstBaseUnit(
        baseUnits: baseUnits,
        unit: unit,
      );

      UnitModel secondBaseUnit = getSecondBaseUnit(
        baseUnits: baseUnits,
        primaryBaseUnit: firstBaseUnit,
      );

      ValueModel argValue = getArgValue(
        argUnit: firstBaseUnit,
        unit: unit,
      );

      bool editMode = !unit.oob;

      bool mandatoryParamsFilled = StringUtils.isNotNullOrEmpty(unit.name) &&
          StringUtils.isNotNullOrEmpty(unit.code);

      bool isNewFirstUnitInGroup = !firstBaseUnit.exists;
      bool isEditSingleUnitInGroup = firstBaseUnit.exists &&
          !secondBaseUnit.exists &&
          unit.id == firstBaseUnit.id;
      bool isBaseConversionRule =
          isNewFirstUnitInGroup || isEditSingleUnitInGroup;

      bool showNonBaseConversionRuleDescription =
          !editMode || input.unitGroup.conversionType == ConversionType.formula;

      bool conversionConfigVisible = mandatoryParamsFilled &&
          !showNonBaseConversionRuleDescription &&
          !isBaseConversionRule;

      bool conversionConfigEditable = conversionConfigVisible;

      String? conversionDescription = UnitDetailsUtils.getConversionDesc(
        unitGroup: input.unitGroup,
        unitData: unit,
        argUnit: firstBaseUnit,
        secondaryBaseUnit: secondBaseUnit,
        argValue: argValue,
        isBaseConversionRule: isBaseConversionRule,
        mandatoryParamsFilled: mandatoryParamsFilled,
        showNonBaseConversionRule: showNonBaseConversionRuleDescription,
      );

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
        argUnit: firstBaseUnit,
        argValue: argValue,
      );

      return Right(
        OutputUnitDetailsModel(
          draft: resultDetails,
          saved: resultDetails,
          unitToSave: null,
          secondaryBaseUnit: secondBaseUnit,
          editMode: editMode,
          conversionConfigVisible: conversionConfigVisible,
          conversionConfigEditable: conversionConfigEditable,
          conversionDescription: conversionDescription,
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

  UnitModel getFirstBaseUnit({
    required List<UnitModel> baseUnits,
    required UnitModel unit,
  }) {
    return baseUnits.where((baseUnit) => baseUnit.id != unit.id).firstOrNull ??
        baseUnits.firstOrNull ??
        UnitModel.none;
  }

  UnitModel getSecondBaseUnit({
    required List<UnitModel> baseUnits,
    required UnitModel primaryBaseUnit,
  }) {
    return baseUnits
            .where((baseUnit) => baseUnit.id != primaryBaseUnit.id)
            .firstOrNull ??
        UnitModel.none;
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
