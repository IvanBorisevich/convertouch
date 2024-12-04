import 'dart:developer';

import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
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
  final CreateConversionUseCase buildNewConversionUseCase;

  const AbstractModifyConversionUseCase({
    required this.buildNewConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    InputConversionModifyModel<D> input,
  ) async {
    try {
      final modifiedGroup = getModifiedGroup(
        unitGroup: input.conversion.unitGroup,
        delta: input.delta,
      );

      final conversionItemsMap = {
        for (var item in input.conversion.targetConversionItems)
          item.unit.id: item
      };

      final modifiedConversionItemsMap = await modifyConversionItems(
        conversionItemsMap: conversionItemsMap,
        delta: input.delta,
      );

      if (modifiedConversionItemsMap.isEmpty) {
        return Right(
          ConversionModel(
            id: input.conversion.id,
            unitGroup: modifiedGroup,
          ),
        );
      }

      var modifiedSourceItem = getModifiedSourceItem(
        currentSourceItem: input.conversion.sourceConversionItem ??
            modifiedConversionItemsMap.values.first,
        modifiedConversionItemsMap: modifiedConversionItemsMap,
        delta: input.delta,
      );

      ConversionModel result;
      if (input.rebuildConversion) {
        result = ObjectUtils.tryGet(
          await buildNewConversionUseCase.execute(
            InputConversionModel(
              unitGroup: modifiedGroup,
              sourceConversionItem: modifiedSourceItem,
              targetUnits: modifiedConversionItemsMap.values
                  .map((conversionItem) => conversionItem.unit)
                  .toList(),
            ),
          ),
        );
      } else {
        result = ConversionModel(
          unitGroup: modifiedGroup,
          sourceConversionItem: modifiedSourceItem,
          targetConversionItems: modifiedConversionItemsMap.values.toList(),
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

  UnitGroupModel getModifiedGroup({
    required UnitGroupModel unitGroup,
    required D delta,
  }) {
    return unitGroup;
  }

  ConversionItemModel getModifiedSourceItem({
    required ConversionItemModel? currentSourceItem,
    required Map<int, ConversionItemModel> modifiedConversionItemsMap,
    required D delta,
  }) {
    if (currentSourceItem != null &&
        modifiedConversionItemsMap.containsKey(currentSourceItem.unit.id)) {
      return modifiedConversionItemsMap[currentSourceItem.unit.id]!;
    }
    return modifiedConversionItemsMap.values.first;
  }

  Future<Map<int, ConversionItemModel>> modifyConversionItems({
    required Map<int, ConversionItemModel> conversionItemsMap,
    required D delta,
  }) async {
    return conversionItemsMap;
  }
}
