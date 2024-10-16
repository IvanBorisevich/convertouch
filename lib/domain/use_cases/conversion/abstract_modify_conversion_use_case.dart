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

    final updatedUnitGroup = modifyConversionGroup(
      input.conversion.unitGroup,
      input.delta,
    );

    final updatedTargetUnitsMap = await modifyTargetUnits(
      targetUnitsMap,
      input.delta,
    );

    var updatedSourceItem = modifySourceConversionItem(
      sourceItem: input.conversion.sourceConversionItem,
      targetUnits: updatedTargetUnitsMap,
      delta: input.delta,
    );

    if (input.rebuildConversion) {
      updatedSourceItem ??= input.conversion.targetConversionItems.firstOrNull;

      InputConversionModel inputParams = InputConversionModel(
        unitGroup: updatedUnitGroup,
        sourceConversionItem: updatedSourceItem,
        targetUnits: updatedTargetUnitsMap.values.toList(),
      );

      return buildNewConversionUseCase.execute(inputParams);
    } else {
      try {
        List<ConversionItemModel> updatedTargetConversionItems = [];

        for (final item in input.conversion.targetConversionItems) {
          if (updatedTargetUnitsMap.containsKey(item.unit.id)) {
            updatedTargetConversionItems.add(
              ConversionItemModel.coalesce(
                item,
                unit: updatedTargetUnitsMap[item.unit.id],
              ),
            );
          }
        }

        updatedSourceItem ??= updatedTargetConversionItems.firstOrNull;

        return Right(
          OutputConversionModel(
            unitGroup: updatedUnitGroup,
            sourceConversionItem: updatedSourceItem,
            targetConversionItems: updatedTargetConversionItems,
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
