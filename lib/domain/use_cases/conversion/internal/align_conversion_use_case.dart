import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class AlignConversionUseCase extends UseCase<ConversionModel, ConversionModel> {
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;
  final CalculateUnitValueUseValue calculateUnitValueUseValue;
  final AddParamSetsToConversionUseCase addParamSetsToConversionUseCase;

  const AlignConversionUseCase({
    required this.calculateParamSetValueUseCase,
    required this.calculateUnitValueUseValue,
    required this.addParamSetsToConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    ConversionModel input,
  ) async {
    ConversionModel alignedConversion = await _alignParams(
      input,
      unitGroupName: input.unitGroup.name,
    );

    alignedConversion = await _alignConversionUnitValues(
      alignedConversion,
      unitGroupName: input.unitGroup.name,
    );

    return Right(alignedConversion);
  }

  Future<ConversionModel> _alignParams(
    ConversionModel conversion, {
    required String unitGroupName,
  }) async {
    ConversionModel alignedConversion = conversion;

    if (conversion.params == null ||
        !conversion.params!.mandatoryParamSetExists) {
      alignedConversion = ObjectUtils.tryGet(
        await addParamSetsToConversionUseCase.execute(
          InputConversionModifyModel<AddParamSetsDelta>(
            conversion: conversion,
            delta: const AddParamSetsDelta(),
          ),
        ),
      );
    }

    if (alignedConversion.params == null) {
      return alignedConversion;
    }

    ConversionParamSetValueModel? paramSetValue =
        alignedConversion.params!.active;

    if (paramSetValue == null) {
      return alignedConversion;
    }

    ConversionParamSetValueModel newParamSetValueModel = ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: paramSetValue,
          unitGroupName: unitGroupName,
          alignCurrentValues: false,
          enableFirstCalculableParamIfNoCalculatedEnabled: false,
        ),
      ),
    );

    var newParams = await alignedConversion.params!.copyWithChangedParamSetById(
      paramSetId: newParamSetValueModel.paramSet.id,
      map: (paramSetValue) async => newParamSetValueModel,
    );

    return alignedConversion.copyWith(
      params: newParams,
    );
  }

  Future<ConversionModel> _alignConversionUnitValues(
    ConversionModel conversion, {
    required String unitGroupName,
  }) async {
    List<ConversionUnitValueModel> alignedUnitValues = [];

    for (var unitValue in conversion.convertedUnitValues) {
      var newUnitValue = ObjectUtils.tryGet(
        await calculateUnitValueUseValue.execute(
          InputUnitValueCalculationModel(
            unitValue: unitValue,
            paramSetValue: conversion.params?.active,
            alignCurrentValue: false,
            unitGroupName: unitGroupName,
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
