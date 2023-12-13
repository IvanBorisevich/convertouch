import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/menu_items_view_event.dart';
import 'package:convertouch/domain/model/output/menu_items_view_states.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeItemsMenuViewUseCase
    extends UseCase<ChangeMenuItemsView, MenuItemsViewStateSet> {
  @override
  Future<Either<Failure, MenuItemsViewStateSet>> execute(
    ChangeMenuItemsView input,
  ) {
    return Future(() {
      try {
        ItemsViewMode pageViewMode = input.targetViewMode;
        ItemsViewMode iconViewMode = _nextMode(input.targetViewMode);
        return Right(
          MenuItemsViewStateSet(
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
