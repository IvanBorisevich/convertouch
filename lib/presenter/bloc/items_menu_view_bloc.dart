import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/events/items_menu_view_event.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsMenuViewBloc extends Bloc<ItemsMenuViewEvent, ItemsMenuViewState> {
  ItemsMenuViewBloc()
      : super(ItemsMenuViewState(
            pageViewMode: ItemsMenuViewMode.grid,
            iconViewMode: _nextMode(ItemsMenuViewMode.grid)));

  @override
  Stream<ItemsMenuViewState> mapEventToState(ItemsMenuViewEvent event) async* {
    if (event is ChangeViewMode) {
      ItemsMenuViewMode pageViewMode = _nextMode(event.currentViewMode);
      ItemsMenuViewMode iconViewMode = _nextMode(pageViewMode);
      yield ItemsMenuViewState(
          pageViewMode: pageViewMode,
          iconViewMode: iconViewMode
      );
    }
  }
}

ItemsMenuViewMode _nextMode(ItemsMenuViewMode currentMode) {
  int currentModeIndex = ItemsMenuViewMode.values.indexOf(currentMode);
  int nextModeIndex = (currentModeIndex + 1) % ItemsMenuViewMode.values.length;
  return ItemsMenuViewMode.values[nextModeIndex];
}
