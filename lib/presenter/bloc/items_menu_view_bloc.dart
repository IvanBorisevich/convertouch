import 'package:convertouch/model/items_menu_view.dart';
import 'package:convertouch/presenter/events/items_menu_view_event.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsMenuViewBloc extends Bloc<ItemsMenuViewEvent, ItemsMenuViewState> {
  ItemsMenuViewBloc()
      : super(const ItemsMenuViewState(itemsMenuView: ItemsMenuView.grid));

  @override
  Stream<ItemsMenuViewState> mapEventToState(ItemsMenuViewEvent event) async* {
    yield ItemsMenuViewState(itemsMenuView: event.itemsMenuView.nextValue());
  }
}
