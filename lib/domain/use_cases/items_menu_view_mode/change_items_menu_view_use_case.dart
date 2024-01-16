import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_menu_items_view_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeItemsMenuViewUseCase
    extends UseCase<ItemsViewMode, OutputMenuItemsViewModel> {
  @override
  Future<Either<Failure, OutputMenuItemsViewModel>> execute(
    ItemsViewMode input,
  ) async {
    try {
      return Right(
        OutputMenuItemsViewModel(
          currentMode: input,
          nextMode: _nextMode(input),
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error during switching items menu view mode: $e"),
      );
    }
  }

  ItemsViewMode _nextMode(ItemsViewMode currentMode) {
    int nextModeIndex = (currentMode.index + 1) % ItemsViewMode.values.length;
    return ItemsViewMode.values[nextModeIndex];
  }
}
