import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class ModifyConversionInputParamsUseCase
    extends UseCase<InputConversionModifyModel, InputConversionModel> {
  @override
  Future<Either<ConvertouchException, InputConversionModel>> execute(
    InputConversionModifyModel input,
  ) async {
    UnitGroupModel? unitGroup = input.unitGroup;
    ConversionItemModel? sourceConversionItem = input.sourceConversionItem;
    List<UnitModel> targetUnits = input.targetUnits;

    try {
      if (input.removedUnitGroupIds.contains(input.unitGroup?.id)) {
        unitGroup = null;
        sourceConversionItem = null;
        targetUnits = [];
      } else {
        if (input.newUnitGroup != null &&
            input.newUnitGroup!.id == input.unitGroup?.id) {
          unitGroup = input.newUnitGroup!;
        }

        if (input.removedUnitIds.isNotEmpty) {
          targetUnits = targetUnits
              .whereNot((unit) => input.removedUnitIds.contains(unit.id))
              .toList();
        }

        if (input.newUnit != null) {
          if (input.newUnit!.id == sourceConversionItem?.unit.id) {
            if (input.newUnit!.unitGroupId ==
                sourceConversionItem?.unit.unitGroupId) {
              sourceConversionItem = ConversionItemModel.coalesce(
                sourceConversionItem,
                unit: input.newUnit!,
              );
            } else {
              sourceConversionItem = null;
            }
          }

          var newUnitIndex =
              targetUnits.indexWhere((unit) => unit.id == input.newUnit!.id);

          if (newUnitIndex != -1) {
            UnitModel removedUnit = targetUnits.removeAt(newUnitIndex);

            if (removedUnit.unitGroupId == input.newUnit!.unitGroupId) {
              targetUnits.insert(newUnitIndex, input.newUnit!);
            }
          }

          if (input.oldUnit != null) {
            var oldUnitIndex =
                targetUnits.indexWhere((unit) => unit.id == input.oldUnit!.id);

            if (oldUnitIndex != -1) {
              targetUnits.replaceRange(
                oldUnitIndex,
                oldUnitIndex + 1,
                [input.newUnit!],
              );
            }
          }
        }
      }
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when modifying input conversion params",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }

    return Right(
      InputConversionModel(
        unitGroup: unitGroup,
        sourceConversionItem: sourceConversionItem,
        targetUnits: targetUnits,
      ),
    );
  }
}
