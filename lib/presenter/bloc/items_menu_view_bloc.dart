import 'package:convertouch/model/items_menu_view_mode.dart';
import 'package:convertouch/presenter/events/items_menu_view_event.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsMenuViewBloc extends Bloc<ItemsMenuViewEvent, ItemsMenuViewState> {
  ItemsMenuViewBloc()
      : super(const ItemsMenuViewState(itemsMenuView: ItemsMenuViewMode.grid));

  @override
  Stream<ItemsMenuViewState> mapEventToState(ItemsMenuViewEvent event) async* {
    if (event is ChangeViewMode) {
      yield ItemsMenuViewState(itemsMenuView: event.viewMode.nextValue());
    }
  }
}
