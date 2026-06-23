import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_align_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class AlignConversionUseCase
    extends UseCase<InputConversionAlignModel, ConversionModel> {
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const AlignConversionUseCase({
    required this.calculateParamSetValueUseCase,
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    InputConversionAlignModel input,
  ) async {
    ConversionModel alignedConversion = input.conversion;

    if (input.alignParams) {
      alignedConversion = await _alignParams(
        input.conversion,
        unitGroupName: input.conversion.unitGroup.name,
        onParamValueUpdated: input.onParamValueUpdated,
        paramIdToRefreshListValues: input.paramIdToRefreshListValues,
        listValuesAutoFetch: input.listValuesAutoFetch,
      );
    }

    if (input.alignUnits) {
      alignedConversion = await _alignConversionUnitValues(
        alignedConversion,
        unitGroupName: input.conversion.unitGroup.name,
        onUnitValueUpdated: (newUnitValue) {
          input.onUnitValueUpdated?.call(
            newUnitValue,
            newUnitValue.unit.id == input.conversion.srcUnitValue?.unit.id,
          );
        },
        listValuesAutoFetch: input.listValuesAutoFetch,
      );
    }

    return Right(alignedConversion);
  }

  Future<ConversionModel> _alignParams(
    ConversionModel conversion, {
    required String unitGroupName,
    required bool listValuesAutoFetch,
    void Function(ConversionParamValueModel)? onParamValueUpdated,
    int? paramIdToRefreshListValues,
  }) async {
    if (conversion.params == null) {
      return conversion;
    }

    final newParams = await conversion.params!.copyWithChangedParamSets(
      map: (paramSetValue) async {
        return ObjectUtils.tryGet(
          await calculateParamSetValueUseCase.execute(
            InputParamSetValueCalculationModel(
              paramSetValue: paramSetValue,
              unitGroupName: unitGroupName,
              delta: paramIdToRefreshListValues != null
                  ? RefreshParamListValuesDelta(
                      paramId: paramIdToRefreshListValues,
                    )
                  : null,
              alignCurrentValues: false,
              listValuesAutoFetch: listValuesAutoFetch,
              listValuesAsyncFetch: true,
              keepSelectedValuesIfNotInList: false,
              enableFirstCalculableParamIfNoCalculatedEnabled: false,
              onParamValueUpdated: onParamValueUpdated,
            ),
          ),
        );
      },
    );

    return conversion.copyWith(
      params: newParams,
    );
  }

  Future<ConversionModel> _alignConversionUnitValues(
    ConversionModel conversion, {
    required String unitGroupName,
    required bool listValuesAutoFetch,
    void Function(ConversionUnitValueModel)? onUnitValueUpdated,
  }) async {
    List<ConversionUnitValueModel> alignedUnitValues = [];

    for (var unitValue in conversion.convertedUnitValues) {
      var newUnitValue = ObjectUtils.tryGet(
        await calculateUnitValueUseValue.execute(
          InputUnitValueCalculationModel(
            itemValue: unitValue,
            paramSetValue: conversion.params?.active,
            alignCurrentValue: false,
            listValuesAutoFetch: listValuesAutoFetch,
            unitGroupName: unitGroupName,
            onItemValueUpdated: onUnitValueUpdated,
          ),
        ),
      );

      alignedUnitValues.add(newUnitValue);
    }

    return conversion.copyWith(
      srcUnitValue: alignedUnitValues.firstWhereOrNull(
        (unitValue) => unitValue.unit.id == conversion.srcUnitValue?.unit.id,
      ),
      convertedUnitValues: alignedUnitValues,
    );
  }
}
