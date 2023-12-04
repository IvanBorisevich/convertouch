import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/usecases/items_menu_view_mode/model/items_menu_view_mode_output.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeItemsMenuViewUseCase
    extends UseCase<ItemsViewMode, ItemsMenuViewModeOutput> {
  @override
  Future<Either<Failure, ItemsMenuViewModeOutput>> execute(
    ItemsViewMode input,
  ) {
    return Future(() {
      try {
        ItemsViewMode pageViewMode = input;
        ItemsViewMode iconViewMode = _nextMode(input);
        return Right(
          ItemsMenuViewModeOutput(
            pageViewMode: pageViewMode,
            iconViewMode: iconViewMode,
          ),
        );
      } catch (e) {
        return Left(
          InternalFailure("Error during switching items menu view mode: $e"),
        );
      }
    });
  }

  ItemsViewMode _nextMode(ItemsViewMode currentMode) {
    int nextModeIndex = (currentMode.index + 1) % ItemsViewMode.values.length;
    return ItemsViewMode.values[nextModeIndex];
  }
}
