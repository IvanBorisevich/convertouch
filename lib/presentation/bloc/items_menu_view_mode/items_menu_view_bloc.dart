import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_event.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_view_mode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsMenuViewBloc extends Bloc<ItemsMenuViewEvent, ItemsViewModeState> {
  ItemsMenuViewBloc()
      : super(ItemsViewModeState(
            pageViewMode: ItemsViewMode.grid,
            iconViewMode: _nextMode(ItemsViewMode.grid)));

  @override
  Stream<ItemsViewModeState> mapEventToState(ItemsMenuViewEvent event) async* {
    if (event is ChangeViewMode) {
      ItemsViewMode pageViewMode = _nextMode(event.currentViewMode);
      ItemsViewMode iconViewMode = _nextMode(pageViewMode);
      yield ItemsViewModeState(
          pageViewMode: pageViewMode,
          iconViewMode: iconViewMode
      );
    }
  }
}

ItemsViewMode _nextMode(ItemsViewMode currentMode) {
  int currentModeIndex = ItemsViewMode.values.indexOf(currentMode);
  int nextModeIndex = (currentModeIndex + 1) % ItemsViewMode.values.length;
  return ItemsViewMode.values[nextModeIndex];
}
