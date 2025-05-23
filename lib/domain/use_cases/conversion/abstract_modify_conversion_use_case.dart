import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  const AbstractModifyConversionUseCase();

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
      InputConversionModifyModel<D> input,) async {
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
        var convertedUnitValues = _calculateUnitValues(
          InputConversionModel(
            unitGroup: modifiedGroup,
            params: newParams?.activeParams,
            sourceUnitValue: newSrcUnitValue,
            targetUnits: modifiedConvertedItemsMap.values
                .map((conversionItem) => conversionItem.unit)
                .toList(),
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

  List<ConversionUnitValueModel> _calculateUnitValues(
      InputConversionModel input) {
    List<ConversionUnitValueModel> convertedUnitValues = [];

    Map<String, String>? mappingTable;
    if (input.params != null && input.params!.hasAllValues) {
      mappingTable = rules.getMappingTableByParams(
        unitGroupName: input.unitGroup.name,
        params: input.params,
      );
    } else {
      mappingTable = rules.getMappingTableByValue(
        unitGroupName: input.unitGroup.name,
        value: input.sourceUnitValue,
      );
    }

    ConversionRule? xToBase = rules
        .getRule(
      unitGroup: input.unitGroup,
      unit: input.sourceUnitValue.unit,
      mappingTable: mappingTable,
    )
        ?.xToBase;

    for (var tgtUnit in input.targetUnits) {
      if (tgtUnit.name == input.sourceUnitValue.unit.name) {
        convertedUnitValues.add(input.sourceUnitValue);
        continue;
      }

      ConversionRule? baseToY = mappingTable != null
          ? UnitRule
          .mappingTable(
        mapping: mappingTable,
        unitCode: tgtUnit.code,
      )
          .baseToY
          : rules
          .getRule(
        unitGroup: input.unitGroup,
        unit: tgtUnit,
      )
          ?.baseToY;

      ValueModel? resultValue = Converter(input.sourceUnitValue.value)
          .apply(xToBase)
          .apply(baseToY)
          .value
          ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);

      ValueModel? resultDefValue = tgtUnit.listType == null
          ? Converter(input.sourceUnitValue.defaultValue)
          .apply(xToBase)
          .apply(baseToY)
          .value
          ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue)
          : null;

      convertedUnitValues.add(
        ConversionUnitValueModel(
          unit: tgtUnit,
          value: resultValue,
          defaultValue: resultDefValue,
        ),
      );
    }
    return convertedUnitValues;
  }
}
