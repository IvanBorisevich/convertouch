import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_new_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

abstract class AbstractModifyConversionUseCase<D extends ConversionModifyDelta>
    extends UseCase<InputConversionModifyModel<D>, OutputConversionModel> {
  final BuildNewConversionUseCase buildNewConversionUseCase;

  const AbstractModifyConversionUseCase({
    required this.buildNewConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionModifyModel<D> input,
  ) async {
    final targetUnitsMap = {
      for (var item in input.conversion.targetConversionItems)
        item.unit.id: item.unit
    };

    final modifiedUnitGroup = modifyConversionGroup(
      input.conversion.unitGroup,
      input.delta,
    );

    final modifiedTargetUnitsMap = await modifyTargetUnits(
      targetUnitsMap,
      input.delta,
    );

    var modifiedSourceItem = modifySourceConversionItem(
      sourceItem: input.conversion.sourceConversionItem,
      targetUnits: modifiedTargetUnitsMap,
      delta: input.delta,
    );

    if (input.rebuildConversion) {
      return _rebuild(
        modifiedUnitGroup: modifiedUnitGroup,
        modifiedSourceItem: modifiedSourceItem ??
            input.conversion.targetConversionItems.firstOrNull,
        modifiedTargetUnitsMap: modifiedTargetUnitsMap,
      );
    } else {
      return _modify(
        modifiedUnitGroup: modifiedUnitGroup,
        modifiedSourceItem: modifiedSourceItem,
        currentTargetItems: input.conversion.targetConversionItems,
        modifiedTargetUnitsMap: modifiedTargetUnitsMap,
      );
    }
  }

  Future<Either<ConvertouchException, OutputConversionModel>> _rebuild({
    required UnitGroupModel modifiedUnitGroup,
    required ConversionItemModel? modifiedSourceItem,
    required Map<int, UnitModel> modifiedTargetUnitsMap,
  }) async {
    InputConversionModel inputParams = InputConversionModel(
      unitGroup: modifiedUnitGroup,
      sourceConversionItem: modifiedSourceItem,
      targetUnits: modifiedTargetUnitsMap.values.toList(),
    );

    return buildNewConversionUseCase.execute(inputParams);
  }

  Future<Either<ConvertouchException, OutputConversionModel>> _modify({
    required UnitGroupModel modifiedUnitGroup,
    required ConversionItemModel? modifiedSourceItem,
    required List<ConversionItemModel> currentTargetItems,
    required Map<int, UnitModel> modifiedTargetUnitsMap,
  }) async {
    try {
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

      return Right(
        OutputConversionModel(
          unitGroup: modifiedUnitGroup,
          sourceConversionItem:
              modifiedSourceItem ?? modifiedTargetConversionItems.firstOrNull,
          targetConversionItems: modifiedTargetConversionItems,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when modifying the existing conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  ConversionItemModel? modifySourceConversionItem({
    required ConversionItemModel? sourceItem,
    required Map<int, UnitModel> targetUnits,
    required D delta,
  }) {
    return sourceItem;
  }

  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    D delta,
  ) {
    return unitGroup;
  }

  Future<Map<int, UnitModel>> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    D delta,
  ) async {
    return targetUnits;
  }
}
