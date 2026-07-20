import 'dart:developer';

import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  const AbstractModifyConversionUseCase();

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

      final oldConvertedUnitValues = {
        for (var item in input.conversion.convertedUnitValues)
          item.unit.id: item
      };

      final modifiedConvertedValues = await newConvertedUnitValues(
        oldConvertedUnitValues: oldConvertedUnitValues,
        unitGroup: modifiedGroup,
        params: input.conversion.params?.active,
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

      bool paramValueChanged = _checkIfParamValueChanged(input);

      if (modifiedConvertedValues.isEmpty) {
        final newConversion = ConversionModel(
          id: input.conversion.id,
          unitGroup: modifiedGroup,
          params: newParams,
        );

        return Right(newConversion);
      }

      ConversionUnitValueModel? newSrcUnitValue = await newSourceUnitValue(
        oldSourceUnitValue:
            modifiedConvertedValues[input.conversion.srcUnitValue?.unit.id] ??
                modifiedConvertedValues.values.first,
        activeParams: newParams?.active,
        unitGroup: modifiedGroup,
        newConvertedUnitValues: modifiedConvertedValues,
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

      bool recalculateUnitValues = input.delta.recalculateUnitValues &&
          paramValueChanged &&
          (input.delta is! EditConversionParamValueDelta ||
              !modifiedGroup.refreshable);

      if (recalculateUnitValues) {
        log("Recalculate unit values, group: ${modifiedGroup.name}");

        var convertedUnitValues = rules.calculateUnitValues(
          InputConversionModel(
            unitGroup: modifiedGroup,
            params: newParams?.active,
            sourceUnitValue: newSrcUnitValue,
            targetItems: modifiedConvertedValues.values.toList(),
          ),
        );

        conversion = conversion.copyWith(
          convertedUnitValues: convertedUnitValues,
        );
      } else {
        conversion = conversion.copyWith(
          convertedUnitValues: modifiedConvertedValues.values.toList(),
        );
      }

      return Right(conversion);
    } catch (e, stackTrace) {
      log("Error when modifying the conversion: $e");
      return Left(
        ConvertouchException(
          message: "Error when modifying the conversion of the group "
              "'${input.conversion.unitGroup.name}'",
          stackTrace: stackTrace,
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
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
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
    return oldConversionParams;
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
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required D delta,
  }) async {
    return oldConvertedUnitValues;
  }

  bool _checkIfParamValueChanged(InputConversionModifyModel<D> input) {
    D delta = input.delta;
    ConversionModel oldConversion = input.conversion;

    bool paramValueChanged = true;

    if (delta is EditConversionParamValueDelta) {
      final newParamValue =
          oldConversion.params?.active?.getParamValueById(delta.paramId);

      paramValueChanged = newParamValue?.value != delta.newValue ||
          newParamValue?.defaultValue != delta.newDefaultValue;
    }

    return paramValueChanged;
  }
}
