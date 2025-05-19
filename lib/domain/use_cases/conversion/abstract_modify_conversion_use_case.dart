import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  final ConvertUnitValuesUseCase convertUnitValuesUseCase;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const AbstractModifyConversionUseCase({
    required this.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    InputConversionModifyModel<D> input,
  ) async {
    try {
      final modifiedGroup = newGroup(
        oldGroup: input.conversion.unitGroup,
        delta: input.delta,
      );

      if (input.conversion.unitGroup.id != modifiedGroup.id) {
        return Right(input.conversion);
      }

      final conversionItemsMap = {
        for (var item in input.conversion.convertedUnitValues)
          item.unit.id: item
      };

      final modifiedConvertedItemsMap = await newConvertedUnitValues(
        oldConvertedUnitValues: conversionItemsMap,
        delta: input.delta,
      );

      ConversionParamSetValueBulkModel? newParams = input.conversion.params;

      if (input.delta is ConversionParamsModifyDelta) {
        newParams = await newConversionParams(
          oldConversionParams: input.conversion.params,
          unitGroup: modifiedGroup,
          srcUnitValue: input.conversion.srcUnitValue,
          delta: input.delta,
        );
      }

      if (modifiedConvertedItemsMap.isEmpty) {
        return Right(
          ConversionModel(
            id: input.conversion.id,
            unitGroup: modifiedGroup,
            params: newParams,
          ),
        );
      }

      ConversionUnitValueModel? newSrcUnitValue = await newSourceUnitValue(
        oldSourceUnitValue: input.conversion.srcUnitValue ??
            modifiedConvertedItemsMap[input.conversion.srcUnitValue?.unit.id] ??
            modifiedConvertedItemsMap.values.first,
        activeParams: newParams?.activeParams,
        unitGroup: modifiedGroup,
        modifiedConvertedItemsMap: modifiedConvertedItemsMap,
        delta: input.delta,
      );

      if (input.delta is ConversionUnitValuesModifyDelta) {
        newParams = await newConversionParamsBySrcUnitValue(
          oldConversionParams: newParams,
          unitGroup: modifiedGroup,
          srcUnitValue: newSrcUnitValue,
          delta: input.delta,
        );
      }

      ConversionModel conversion = ConversionModel(
        id: input.conversion.id,
        unitGroup: modifiedGroup,
        srcUnitValue: newSrcUnitValue,
        params: newParams,
      );

      if (input.recalculateUnitValues) {
        var convertedUnitValues = ObjectUtils.tryGet(
          await convertUnitValuesUseCase.execute(
            InputConversionModel(
              unitGroup: modifiedGroup,
              params: newParams?.activeParams,
              sourceUnitValue: newSrcUnitValue,
              targetUnits: modifiedConvertedItemsMap.values
                  .map((conversionItem) => conversionItem.unit)
                  .toList(),
            ),
          ),
        );

        conversion = conversion.copyWith(
          convertedUnitValues: convertedUnitValues,
        );
      } else {
        conversion = conversion.copyWith(
          convertedUnitValues: modifiedConvertedItemsMap.values.toList(),
        );
      }

      return Right(conversion);
    } catch (e, stackTrace) {
      log("Error when modifying the conversion: $e");
      return Left(
        InternalException(
          message: "Error when modifying the conversion of the group "
              "'${input.conversion.unitGroup.name}'",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  UnitGroupModel newGroup({
    required UnitGroupModel oldGroup,
    required D delta,
  }) {
    return oldGroup;
  }

  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required D delta,
  }) async {
    if (delta is EditConversionParamValueDelta ||
        delta is SelectParamSetDelta ||
        delta is RemoveParamSetsDelta ||
        delta is ReplaceConversionParamUnitDelta ||
        delta is AddUnitsToConversionDelta) {
      UnitModel srcUnit = oldSourceUnitValue.unit;

      if (activeParams == null ||
          !activeParams.paramSet.mandatory && !activeParams.hasAllValues) {
        return oldSourceUnitValue.hasValue
            ? oldSourceUnitValue
            : await _calculateDefaults(srcUnit);
      }

      if (activeParams.hasAllValues || activeParams.paramSet.mandatory) {
        return rules.calculateSrcValueByParams(
          params: activeParams,
          unitGroupName: unitGroup.name,
          srcUnit: srcUnit,
        );
      }

      return oldSourceUnitValue;
    }

    return oldSourceUnitValue;
  }

  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required D delta,
  }) async {
    return oldConversionParams!;
  }

  Future<ConversionParamSetValueBulkModel?> newConversionParamsBySrcUnitValue({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel srcUnitValue,
    required D delta,
  }) async {
    return oldConversionParams;
  }

  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required D delta,
  }) async {
    return oldConvertedUnitValues;
  }

  Future<ConversionUnitValueModel> _calculateDefaults(UnitModel srcUnit) async {
    ValueModel? defaultValue = ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(srcUnit),
    );
    return ConversionUnitValueModel(
      unit: srcUnit,
      value: srcUnit.listType != null ? defaultValue : null,
      defaultValue: srcUnit.listType != null ? null : defaultValue,
    );
  }
}
