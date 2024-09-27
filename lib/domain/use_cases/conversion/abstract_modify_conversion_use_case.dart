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

    if (input.rebuildConversion) {
      final updatedSourceItem = modifySourceConversionItem(
            input.conversion.sourceConversionItem,
            input.delta,
          ) ??
          input.conversion.targetConversionItems.firstOrNull;

      final updatedTargetUnits =
          modifyTargetUnits(targetUnitsMap, input.delta).values.toList();

      InputConversionModel inputParams = InputConversionModel(
        unitGroup: modifyConversionGroup(
          input.conversion.unitGroup!,
          input.delta,
        ),
        sourceConversionItem: updatedSourceItem,
        targetUnits: updatedTargetUnits,
      );
      return buildNewConversionUseCase.execute(inputParams);
    } else {
      try {
        final updatedUnitGroup = modifyConversionGroup(
          input.conversion.unitGroup!,
          input.delta,
        );

        final updatedTargetConversionItems = _modifyTargetConversionItems(
          input.conversion.targetConversionItems,
          modifyTargetUnits(targetUnitsMap, input.delta),
        );

        final updatedSourceItem = modifySourceConversionItem(
              input.conversion.sourceConversionItem,
              input.delta,
            ) ??
            updatedTargetConversionItems.firstOrNull;

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

  List<ConversionItemModel> _modifyTargetConversionItems(
    List<ConversionItemModel> currentTargetItems,
    Map<int, UnitModel> targetUnitMapsUpdated,
  ) {
    return currentTargetItems
        .map(
          (item) => ConversionItemModel.coalesce(
            item,
            unit: targetUnitMapsUpdated[item.unit.id],
          ),
        )
        .toList();
  }

  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    D delta,
  );

  UnitGroupModel modifyConversionGroup(UnitGroupModel unitGroup, D delta);

  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    D delta,
  );
}
