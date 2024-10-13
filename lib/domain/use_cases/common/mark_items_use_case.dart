import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_marking_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_marking_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class MarkItemsUseCase
    extends UseCase<InputItemsMarkingModel, OutputItemsMarkingModel> {
  @override
  Future<Either<ConvertouchException, OutputItemsMarkingModel>> execute(
    InputItemsMarkingModel input,
  ) async {
    List<int> markedIds = [];

    try {
      if (input.alreadyMarkedIds.isNotEmpty) {
        markedIds = List.of(input.alreadyMarkedIds);
      }

      if (input.excludedIds.contains(input.newMarkedId)) {
        return Right(
          OutputItemsMarkingModel(
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
          .whereNot((id) => input.excludedIds.contains(id))
          .toList();

      return Right(
        OutputItemsMarkingModel(
          markedIds: markedIds,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when marking the item with id = ${input.newMarkedId}",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
