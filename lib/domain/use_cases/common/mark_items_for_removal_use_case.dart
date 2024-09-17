import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_removal_mark_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_for_removal_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class MarkItemsForRemovalUseCase
    extends UseCase<InputItemsRemovalMarkModel, OutputItemsForRemovalModel> {
  @override
  Future<Either<ConvertouchException, OutputItemsForRemovalModel>> execute(
    InputItemsRemovalMarkModel input,
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
          .whereNot((id) => input.oobIds.contains(id))
          .toList();

      return Right(
        OutputItemsForRemovalModel(
          markedIds: markedIds,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when marking the item with id = ${input.newMarkedId}"
              " for removal",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
