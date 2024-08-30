import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_for_removal_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_for_removal_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class MarkGroupsForRemovalUseCase
    extends UseCase<InputItemsForRemovalModel, OutputItemsForRemovalModel> {
  @override
  Future<Either<ConvertouchException, OutputItemsForRemovalModel>> execute(
    InputItemsForRemovalModel input,
  ) async {
    List<int> markedIds = [];

    try {
      if (input.alreadyMarkedIds.isNotEmpty) {
        markedIds = input.alreadyMarkedIds;
      }

      if (input.oobIds.contains(input.newMarkedId)) {
        return Right(
          OutputItemsForRemovalModel(
            markedIds: markedIds,
          ),
        );
      }

      if (!markedIds.contains(input.newMarkedId)) {
        markedIds.add(input.newMarkedId);
      } else {
        markedIds.remove(input.newMarkedId);
      }

      markedIds = markedIds
          .whereNot((unitGroupId) => input.oobIds.contains(unitGroupId))
          .toList();

      return Right(
        OutputItemsForRemovalModel(
          markedIds: markedIds,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when marking a group for removal",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
