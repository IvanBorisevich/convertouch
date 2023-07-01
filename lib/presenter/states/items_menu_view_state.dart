import 'package:convertouch/model/items_menu_view.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ItemsMenuViewState extends BlocState {
  const ItemsMenuViewState({
    required this.itemsMenuView,
  });

  final ItemsMenuView itemsMenuView;

  @override
  List<Object> get props => [
    itemsMenuView
  ];

  @override
  String toString() {
    return 'ItemsMenuViewState{itemsMenuView: $itemsMenuView}';
  }
}