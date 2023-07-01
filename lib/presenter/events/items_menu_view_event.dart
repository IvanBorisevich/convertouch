import 'package:convertouch/model/items_menu_view.dart';
import 'package:convertouch/presenter/events/base_event.dart';

class ItemsMenuViewEvent extends ConvertouchEvent {
  const ItemsMenuViewEvent({
    required this.itemsMenuView
  });

  final ItemsMenuView itemsMenuView;

  @override
  List<Object> get props => [
    itemsMenuView
  ];

  @override
  String toString() {
    return 'ItemsMenuViewEvent{itemsMenuView: $itemsMenuView}';
  }
}