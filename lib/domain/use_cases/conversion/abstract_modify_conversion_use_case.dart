import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_new_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, ConversionModel> {
  final BuildNewConversionUseCase buildNewConversionUseCase;

  const AbstractModifyConversionUseCase({
    required this.buildNewConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    InputConversionModifyModel<D> input,
  ) async {
    try {
      final targetUnitsMap = {
        for (var item in input.conversion.targetConversionItems)
          item.unit.id: item.unit
      };

      final modifiedTargetUnitsMap = await modifyTargetUnits(
        targetUnitsMap,
        input.delta,
      );

      var modifiedSourceItem = modifySourceConversionItem(
        sourceItem: input.conversion.sourceConversionItem,
        targetUnits: modifiedTargetUnitsMap,
        delta: input.delta,
      );

      ConversionModel result;
      if (input.rebuildConversion) {
        result = await _rebuild(
          modifiedUnitGroup: input.conversion.unitGroup,
          modifiedSourceItem: modifiedSourceItem ??
              input.conversion.targetConversionItems.firstOrNull,
          modifiedTargetUnitsMap: modifiedTargetUnitsMap,
        );
      } else {
        result = await _modify(
          modifiedUnitGroup: input.conversion.unitGroup,
          modifiedSourceItem: modifiedSourceItem,
          currentTargetItems: input.conversion.targetConversionItems,
          modifiedTargetUnitsMap: modifiedTargetUnitsMap,
        );
      }

      return Right(
        ConversionModel.coalesce(
          result,
          id: input.conversion.id,
        ),
      );
    } catch (e, stackTrace) {
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

  Future<ConversionModel> _rebuild({
    required UnitGroupModel modifiedUnitGroup,
    required ConversionItemModel? modifiedSourceItem,
    required Map<int, UnitModel> modifiedTargetUnitsMap,
  }) async {
    InputConversionModel inputParams = InputConversionModel(
      unitGroup: modifiedUnitGroup,
      sourceConversionItem: modifiedSourceItem,
      targetUnits: modifiedTargetUnitsMap.values.toList(),
    );

    return ObjectUtils.tryGet(
      await buildNewConversionUseCase.execute(inputParams),
    );
  }

  Future<ConversionModel> _modify({
    required UnitGroupModel modifiedUnitGroup,
    required ConversionItemModel? modifiedSourceItem,
    required List<ConversionItemModel> currentTargetItems,
    required Map<int, UnitModel> modifiedTargetUnitsMap,
  }) async {
    List<ConversionItemModel> modifiedTargetConversionItems = [];

    for (final item in currentTargetItems) {
      if (modifiedTargetUnitsMap.containsKey(item.unit.id)) {
        modifiedTargetConversionItems.add(
          ConversionItemModel.coalesce(
            item,
            unit: modifiedTargetUnitsMap[item.unit.id],
          ),
        );
      }
    }

    return ConversionModel(
      unitGroup: modifiedUnitGroup,
      sourceConversionItem:
          modifiedSourceItem ?? modifiedTargetConversionItems.firstOrNull,
      targetConversionItems: modifiedTargetConversionItems,
    );
  }

  ConversionItemModel? modifySourceConversionItem({
    required ConversionItemModel? sourceItem,
    required Map<int, UnitModel> targetUnits,
    required D delta,
  }) {
    return sourceItem;
  }

  Future<Map<int, UnitModel>> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    D delta,
  ) async {
    return targetUnits;
  }
}
