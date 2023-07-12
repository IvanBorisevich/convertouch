import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ItemsMenuViewState extends ConvertouchBlocState {
  const ItemsMenuViewState({
    required this.itemsMenuView,
  });

  final ItemsMenuViewMode itemsMenuView;

  @override
  List<Object> get props => [
    itemsMenuView
  ];

  @override
  String toString() {
    return 'ItemsMenuViewState{itemsMenuView: $itemsMenuView}';
  }
}