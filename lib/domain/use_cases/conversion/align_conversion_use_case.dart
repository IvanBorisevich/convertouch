import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_align_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
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
        paramIdToRefreshListValues: input.paramIdToRefreshListValues,
      );
    }

    if (input.alignUnits) {
      alignedConversion = await _alignConversionUnitValues(
        alignedConversion,
      );
    }

    return Right(alignedConversion);
  }

  Future<ConversionModel> _alignParams(
    ConversionModel conversion, {
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
              conversionGroup: conversion.unitGroup,
              startParamId: paramIdToRefreshListValues,
              keepSelectedValuesIfNotInList: false,
              enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
      ConversionModel conversion) async {
    List<ConversionUnitValueModel> alignedUnitValues = [];

    for (var unitValue in conversion.convertedUnitValues) {
      var newUnitValue = ObjectUtils.tryGet(
        await calculateUnitValueUseValue.execute(
          InputUnitValueCalculationModel(
            itemValue: unitValue,
            paramSetValue: conversion.params?.active,
            conversionGroup: conversion.unitGroup,
            initDefaultValueIfEmpty: false,
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
