import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  final ConvertUnitValuesUseCase convertUnitValuesUseCase;

  const AbstractModifyConversionUseCase({
    required this.convertUnitValuesUseCase,
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
      ConversionUnitValueModel? newSrcUnitValue = input.conversion.srcUnitValue;

      if (input.delta is ConversionParamValuesModifyDelta) {
        newParams = await newConversionParams(
          oldConversionParams: input.conversion.params,
          unitGroup: modifiedGroup,
          srcUnitValue: input.conversion.srcUnitValue,
          delta: input.delta,
        );

        if (newParams != null) {
          newSrcUnitValue = await newSourceUnitValueByParams(
            oldSourceUnitValue: input.conversion.srcUnitValue,
            activeParams: newParams.activeParams,
            delta: input.delta,
          );
        }
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

      if (input.delta is ConversionUnitValuesModifyDelta) {
        newSrcUnitValue = await newSourceUnitValue(
          oldSourceUnitValue: input.conversion.srcUnitValue,
          activeParams: newParams?.activeParams,
          unitGroup: modifiedGroup,
          modifiedConvertedItemsMap: modifiedConvertedItemsMap,
          delta: input.delta,
        );

        newParams = await newConversionParamsBySrcUnitValue(
          oldConversionParams: newParams,
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
              sourceUnitValue: newSrcUnitValue!,
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
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required D delta,
  }) async {
    if (oldSourceUnitValue != null) {
      return oldSourceUnitValue;
    } else {
      var srcUnitId = oldSourceUnitValue?.unit.id;
      if (srcUnitId != null &&
          modifiedConvertedItemsMap.containsKey(srcUnitId)) {
        return modifiedConvertedItemsMap[srcUnitId]!;
      } else {
        return modifiedConvertedItemsMap.values.first;
      }
    }
  }

  Future<ConversionUnitValueModel?> newSourceUnitValueByParams({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel activeParams,
    required D delta,
  }) async {
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
}
