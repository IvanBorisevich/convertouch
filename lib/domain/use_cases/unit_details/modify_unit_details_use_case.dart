import 'package:basic_utils/basic_utils.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/unit_details_utils.dart';
import 'package:either_dart/either.dart';

abstract class ModifyUnitDetailsUseCase<T>
    extends UseCase<InputUnitDetailsModifyModel<T>, OutputUnitDetailsModel> {
  const ModifyUnitDetailsUseCase();

  @override
  Future<Either<ConvertouchException, OutputUnitDetailsModel>> execute(
    InputUnitDetailsModifyModel<T> input,
  ) async {
    try {
      final draftUnitGroup = getDraftUnitGroup(input);
      final draftUnitName = getDraftUnitName(input);
      final draftUnitCode = getDraftUnitCode(input);
      final draftUnitSymbol = input.draft.unitData.symbol;
      final draftValueType = input.draft.unitData.valueType;
      final draftMinValue = input.draft.unitData.minValue;
      final draftMaxValue = input.draft.unitData.maxValue;
      final draftUnitValue = getDraftUnitValue(input);
      final draftArgUnit = await getDraftArgUnit(input);
      final draftArgValue = getDraftArgValue(input);
      final draftCoefficient = UnitDetailsUtils.calcNewUnitCoefficient(
        value: draftUnitValue,
        argUnit: draftArgUnit,
        argValue: draftArgValue,
      );

      final savedUnitGroup = input.saved.unitGroup;
      final savedUnitName = input.saved.unitData.name;
      final savedUnitCode = ObjectUtils.coalesceStringOrDefault(
        str1: input.saved.unitData.code,
        str2: UnitDetailsUtils.calcInitialUnitCode(draftUnitName),
      );
      final savedUnitSymbol = input.saved.unitData.symbol;
      final savedValueType = input.saved.unitData.valueType;
      final savedMinValue = input.saved.unitData.minValue;
      final savedMaxValue = input.saved.unitData.maxValue;
      final savedUnitValue = input.saved.value;
      final savedArgUnit = input.saved.argUnit;
      final savedArgValue = input.saved.argValue;
      final savedCoefficient = UnitDetailsUtils.calcNewUnitCoefficient(
        value: savedUnitValue,
        argUnit: savedArgUnit,
        argValue: savedArgValue,
      );

      final resultUnitName = ObjectUtils.coalesceStringOrDefault(
        str1: draftUnitName,
        str2: savedUnitName,
      );
      final resultUnitCode = ObjectUtils.coalesceStringOrDefault(
        str1: draftUnitCode,
        str2: savedUnitCode,
      );
      final resultUnitSymbol = ObjectUtils.coalesceStringOrNull(
        str1: draftUnitSymbol,
        str2: savedUnitSymbol,
      );
      final resultValueType = ObjectUtils.coalesceOrNull(
        v1: draftValueType,
        v2: savedValueType,
      );

      final mandatoryParamsFilled =
          StringUtils.isNotNullOrEmpty(resultUnitName) &&
              StringUtils.isNotNullOrEmpty(resultUnitCode);
      final unitGroupChanged = draftUnitGroup != savedUnitGroup;
      final unitNameChanged = resultUnitName != savedUnitName;
      final unitCodeChanged = resultUnitCode != savedUnitCode;
      final unitSymbolChanged = resultUnitSymbol != savedUnitSymbol;
      final coefficientChanged = DoubleValueUtils.areNotEqual(
        draftCoefficient,
        savedCoefficient,
      );

      final deltaDetected = mandatoryParamsFilled &&
          (unitGroupChanged ||
              unitNameChanged ||
              unitCodeChanged ||
              unitSymbolChanged ||
              coefficientChanged);

      final unitToSave = deltaDetected
          ? UnitModel(
              id: input.saved.unitData.id,
              name: resultUnitName,
              code: resultUnitCode,
              symbol: resultUnitSymbol,
              valueType: resultValueType,
              coefficient: draftCoefficient,
              unitGroupId: draftUnitGroup.id!,
            )
          : null;

      bool conversionConfigEditable =
          draftArgUnit.exists && input.draft.unitData.id != draftArgUnit.id;

      String? conversionDescription = UnitDetailsUtils.getConversionDesc(
        unitGroup: draftUnitGroup,
        unitData: UnitModel(
          name: draftUnitName,
          code: draftUnitCode,
          coefficient: draftCoefficient,
        ),
        argUnit: draftArgUnit,
        argValue: draftArgValue,
      );

      final note = getNote(input);

      return Right(
        OutputUnitDetailsModel(
          draft: UnitDetailsModel(
            unitGroup: draftUnitGroup,
            unitData: UnitModel(
              name: draftUnitName,
              code: draftUnitCode,
              symbol: draftUnitSymbol,
              valueType: draftValueType,
              minValue: draftMinValue,
              maxValue: draftMaxValue,
            ),
          ),
          saved: UnitDetailsModel(
            unitGroup: savedUnitGroup,
            unitData: UnitModel(
              name: savedUnitName,
              code: savedUnitCode,
              symbol: savedUnitSymbol,
              valueType: savedValueType,
              minValue: savedMinValue,
              maxValue: savedMaxValue,
            ),
          ),
          unitToSave: unitToSave,
          editMode: true,
          conversionConfigEditable: conversionConfigEditable,
          conversionDescription: conversionDescription,
          unitGroupChanged: unitGroupChanged,
          note: note,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: getErrorMessage(),
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  UnitGroupModel getDraftUnitGroup(InputUnitDetailsModifyModel<T> input) {
    return input.draft.unitGroup;
  }

  String getDraftUnitName(InputUnitDetailsModifyModel<T> input) {
    return input.draft.unitData.name;
  }

  String getDraftUnitCode(InputUnitDetailsModifyModel<T> input) {
    return input.draft.unitData.code;
  }

  ValueModel getDraftUnitValue(InputUnitDetailsModifyModel<T> input) {
    return input.draft.value;
  }

  Future<UnitModel> getDraftArgUnit(
    InputUnitDetailsModifyModel<T> input,
  ) async {
    return input.draft.argUnit;
  }

  ValueModel getDraftArgValue(InputUnitDetailsModifyModel<T> input) {
    return input.draft.argValue;
  }

  String? getNote(InputUnitDetailsModifyModel<T> input) {
    return null;
  }

  String getErrorMessage();
}
