import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/create_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  final CreateConversionUseCase createConversionUseCase;

  const AbstractModifyConversionUseCase({
    required this.createConversionUseCase,
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

      final conversionParams = await modifyConversionParamValues(
        currentParams: input.conversion.params,
        delta: input.delta,
      );

      final conversionItemsMap = {
        for (var item in input.conversion.conversionUnitValues)
          item.unit.id: item
      };

      final modifiedConversionItemsMap = await modifyConversionUnitValues(
        conversionItemsMap: conversionItemsMap,
        delta: input.delta,
      );

      if (modifiedConversionItemsMap.isEmpty) {
        return Right(
          ConversionModel(
            id: input.conversion.id,
            unitGroup: modifiedGroup,
            params: conversionParams,
          ),
        );
      }

      var modifiedSourceUnitValue = modifySourceUnitValue(
        currentSourceItem: input.conversion.sourceConversionItem ??
            modifiedConversionItemsMap.values.first,
        modifiedConversionItemsMap: modifiedConversionItemsMap,
        delta: input.delta,
      );

      ConversionModel result;
      if (input.rebuildConversion) {
        result = ObjectUtils.tryGet(
          await createConversionUseCase.execute(
            InputConversionModel(
              conversionId: input.conversion.id,
              unitGroup: modifiedGroup,
              params: conversionParams,
              sourceUnitValue: modifiedSourceUnitValue,
              targetUnits: modifiedConversionItemsMap.values
                  .map((conversionItem) => conversionItem.unit)
                  .toList(),
            ),
          ),
        );
      } else {
        result = ConversionModel(
          unitGroup: modifiedGroup,
          sourceConversionItem: modifiedSourceUnitValue,
          params: conversionParams,
          conversionUnitValues: modifiedConversionItemsMap.values.toList(),
        );
      }

      return Right(
        ConversionModel.coalesce(
          result,
          id: input.conversion.id,
        ),
      );
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

  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required D delta,
  }) async {
    return currentParams;
  }

  ConversionUnitValueModel modifySourceUnitValue({
    required ConversionUnitValueModel? currentSourceItem,
    required Map<int, ConversionUnitValueModel> modifiedConversionItemsMap,
    required D delta,
  }) {
    if (currentSourceItem != null &&
        modifiedConversionItemsMap.containsKey(currentSourceItem.unit.id)) {
      return modifiedConversionItemsMap[currentSourceItem.unit.id]!;
    }
    return modifiedConversionItemsMap.values.first;
  }

  Future<Map<int, ConversionUnitValueModel>> modifyConversionUnitValues({
    required Map<int, ConversionUnitValueModel> conversionItemsMap,
    required D delta,
  }) async {
    return conversionItemsMap;
  }
}
