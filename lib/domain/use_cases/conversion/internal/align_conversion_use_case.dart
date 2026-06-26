import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_align_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_item_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class AlignConversionUseCase extends UseCase<InputConversionAlignModel, void> {
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const AlignConversionUseCase({
    required this.calculateParamSetValueUseCase,
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<Either<ConvertouchException, void>> execute(
    InputConversionAlignModel input,
  ) async {
    if (input.alignParams) {
      Future<ConversionModel> alignedConversionByParamsFuture = _alignParams(
        input.conversion,
        unitGroupName: input.conversion.unitGroup.name,
        paramIdToRefreshListValues: input.paramIdToRefreshListValues,
        fetchListValues: input.fetchListValues,
        alignCurrentValues: input.alignCurrentValues,
        onParamValueUpdated: input.onParamValueUpdated,
      );

      if (input.asyncAlign) {
        alignedConversionByParamsFuture.then((alignedConversion) {
          input.onConversionParamsAligned?.call(alignedConversion);

          log("${DateTime.now()} - [async] Conversion params have been aligned, unit values size = ${alignedConversion.convertedUnitValues.length}");

          if (input.alignUnits) {
            log("${DateTime.now()} - [async] Align units");

            _alignConversionUnitValues(
              alignedConversion,
              unitGroupName: alignedConversion.unitGroup.name,
              onUnitValueUpdated: input.onUnitValueUpdated,
              fetchListValues: input.fetchListValues,
              alignCurrentValues: input.alignCurrentValues,
              onUnitValuesAligned: input.onConversionUnitValuesAligned,
            );
          }
        });
      } else {
        ConversionModel alignedConversion =
            await alignedConversionByParamsFuture;

        input.onConversionParamsAligned?.call(alignedConversion);

        log("${DateTime.now()} - Conversion params have been aligned");

        if (input.alignUnits) {
          log("${DateTime.now()} - Align units");

          await _alignConversionUnitValues(
            alignedConversion,
            unitGroupName: alignedConversion.unitGroup.name,
            onUnitValueUpdated: input.onUnitValueUpdated,
            fetchListValues: input.fetchListValues,
            alignCurrentValues: input.alignCurrentValues,
            onUnitValuesAligned: input.onConversionUnitValuesAligned,
            asyncAlign: false,
          );

          log("${DateTime.now()} - Conversion unit values have been aligned by params");
        }
      }
    } else if (input.alignUnits) {
      _alignConversionUnitValues(
        input.conversion,
        unitGroupName: input.conversion.unitGroup.name,
        onUnitValueUpdated: input.onUnitValueUpdated,
        fetchListValues: input.fetchListValues,
        alignCurrentValues: input.alignCurrentValues,
        onUnitValuesAligned: input.onConversionUnitValuesAligned,
        asyncAlign: input.asyncAlign,
      );

      log("${DateTime.now()} - Conversion unit values have been aligned");
    }

    return const Right(null);
  }

  Future<ConversionModel> _alignParams(
    ConversionModel conversion, {
    required String unitGroupName,
    required bool fetchListValues,
    required bool alignCurrentValues,
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
              alignCurrentValues: alignCurrentValues,
              fetchListValues: fetchListValues,
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

  Future<void> _alignConversionUnitValues(
    ConversionModel conversion, {
    required String unitGroupName,
    required bool fetchListValues,
    required bool alignCurrentValues,
    void Function(ConversionUnitValueModel, bool)? onUnitValueUpdated,
    void Function(ConversionModel)? onUnitValuesAligned,
    bool asyncAlign = true,
  }) async {
    List<ConversionUnitValueModel> alignedUnitValues = [];
    List<ItemValueFuture<ConversionUnitValueModel>> futureAlignedUnitValues =
        [];

    for (var unitValue in conversion.convertedUnitValues) {
      var unitValueCalculationOutput = ObjectUtils.tryGet(
        await calculateUnitValueUseValue.execute(
          InputUnitValueCalculationModel(
            itemValue: unitValue,
            paramSetValue: conversion.params?.active,
            alignCurrentValue: alignCurrentValues,
            fetchListValues: fetchListValues,
            unitGroupName: unitGroupName,
            onItemValueUpdated: (newUnitValue) {
              onUnitValueUpdated?.call(
                newUnitValue,
                newUnitValue.unit.id == conversion.srcUnitValue?.unit.id,
              );
            },
          ),
        ),
      );

      if (unitValueCalculationOutput.itemValueFuture != null) {
        futureAlignedUnitValues
            .add(unitValueCalculationOutput.itemValueFuture!);
      } else {
        alignedUnitValues.add(unitValueCalculationOutput.itemValue);
      }
    }

    ConversionModel alignedConversion = conversion;

    if (alignedUnitValues.isNotEmpty) {
      log("${DateTime.now()} - Align non-delayed conversion unit values");

      alignedConversion = conversion.copyWith(
        srcUnitValue: alignedUnitValues.firstWhereOrNull(
          (unitValue) => unitValue.unit.id == conversion.srcUnitValue?.unit.id,
        ),
        convertedUnitValues: alignedUnitValues,
      );

      onUnitValuesAligned?.call(alignedConversion);

      log("${DateTime.now()} - Non-delayed conversion unit values "
          "have been aligned");
    }

    if (futureAlignedUnitValues.isEmpty) {
      log("${DateTime.now()} - No delayed conversion unit values to be aligned");
      return;
    }

    if (asyncAlign) {
      log("${DateTime.now()} - [async] Delayed conversion units align starting");

      Future.wait(futureAlignedUnitValues).then(
        (alignedEitherValues) {
          List<ConversionUnitValueModel> delayedUnitValues = alignedEitherValues
              .map((eitherUnitValue) => ObjectUtils.tryGet(eitherUnitValue))
              .toList();

          alignedConversion = alignedConversion.copyWith(
            srcUnitValue: delayedUnitValues.firstWhereOrNull(
              (unitValue) =>
                  unitValue.unit.id == alignedConversion.srcUnitValue?.unit.id,
            ),
            convertedUnitValues: delayedUnitValues,
          );

          onUnitValuesAligned?.call(alignedConversion);

          log("${DateTime.now()} - [async] Delayed conversion unit values "
              "have been aligned");
        },
      );
    } else {
      log("${DateTime.now()} - Delayed conversion units align starting");

      List<ConversionUnitValueModel> delayedUnitValues =
          (await Future.wait(futureAlignedUnitValues))
              .map((eitherUnitValue) => ObjectUtils.tryGet(eitherUnitValue))
              .toList();

      alignedConversion = alignedConversion.copyWith(
        srcUnitValue: delayedUnitValues.firstWhereOrNull(
          (unitValue) =>
              unitValue.unit.id == alignedConversion.srcUnitValue?.unit.id,
        ),
        convertedUnitValues: delayedUnitValues,
      );

      onUnitValuesAligned?.call(alignedConversion);

      log("${DateTime.now()} - Delayed conversion unit values have been aligned");
    }
  }
}
