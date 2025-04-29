import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
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
      final modifiedGroup = modifyGroup(
        unitGroup: input.conversion.unitGroup,
        delta: input.delta,
      );

      if (input.conversion.unitGroup.id != modifiedGroup.id) {
        return Right(input.conversion);
      }

      final newParams = await modifyConversionParamValues(
        currentParams: input.conversion.params,
        unitGroup: modifiedGroup,
        srcUnitValue: input.conversion.srcUnitValue,
        delta: input.delta,
      );

      final conversionItemsMap = {
        for (var item in input.conversion.convertedUnitValues)
          item.unit.id: item
      };

      final modifiedConvertedItemsMap = await modifyConversionUnitValues(
        conversionItemsMap: conversionItemsMap,
        delta: input.delta,
      );

      if (modifiedConvertedItemsMap.isEmpty) {
        return Right(
          ConversionModel(
            id: input.conversion.id,
            unitGroup: modifiedGroup,
            params: newParams,
          ),
        );
      }

      ConversionParamSetValueModel? activeParams =
          newParams?.paramSetValues[newParams.selectedIndex];

      var srcUnitValue = await getSrcUnitValue(
        input: input,
        modifiedConvertedItemsMap: modifiedConvertedItemsMap,
        activeParams: activeParams,
      );

      ConversionModel conversion = ConversionModel(
        id: input.conversion.id,
        unitGroup: modifiedGroup,
        srcUnitValue: srcUnitValue,
        params: newParams,
      );

      if (input.recalculateUnitValues) {
        var convertedUnitValues = ObjectUtils.tryGet(
          await convertUnitValuesUseCase.execute(
            InputConversionModel(
              unitGroup: modifiedGroup,
              params: activeParams,
              sourceUnitValue: srcUnitValue,
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

  UnitGroupModel modifyGroup({
    required UnitGroupModel unitGroup,
    required D delta,
  }) {
    return unitGroup;
  }

  Future<ConversionUnitValueModel> getSrcUnitValue({
    required InputConversionModifyModel<D> input,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required ConversionParamSetValueModel? activeParams,
  }) async {
    var newSrcUnitValue = newSourceUnitValue(
      modifiedConvertedItemsMap: modifiedConvertedItemsMap,
      delta: input.delta,
    );

    ConversionUnitValueModel result;

    if (newSrcUnitValue != null) {
      result = newSrcUnitValue;
    } else {
      var srcUnitId = input.conversion.srcUnitValue?.unit.id;
      if (srcUnitId != null &&
          modifiedConvertedItemsMap.containsKey(srcUnitId)) {
        result = modifiedConvertedItemsMap[srcUnitId]!;
      } else {
        result = modifiedConvertedItemsMap.values.first;
      }
    }

    if (activeParams != null && !activeParams.applicable) {
      return ConversionUnitValueModel(
        unit: result.unit,
      );
    }

    ValueModel? defaultValue = result.defaultValue;
    if (defaultValue == null) {
      String? defaultValueStr = ObjectUtils.tryGet(
        await calculateDefaultValueUseCase.execute(
          result.unit,
        ),
      );

      defaultValue = ValueModel.any(defaultValueStr);
    }

    if (result.unit.listType != null) {
      result = ConversionUnitValueModel(
        unit: result.unit,
        value: result.value ?? defaultValue,
      );
    } else {
      result = result.copyWith(
        defaultValue: defaultValue,
      );
    }

    return result;
  }

  ConversionUnitValueModel? newSourceUnitValue({
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required D delta,
  }) {
    return null;
  }

  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required D delta,
  }) async {
    return currentParams;
  }

  Future<Map<int, ConversionUnitValueModel>> modifyConversionUnitValues({
    required Map<int, ConversionUnitValueModel> conversionItemsMap,
    required D delta,
  }) async {
    return conversionItemsMap;
  }
}
