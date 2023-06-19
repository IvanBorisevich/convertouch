import 'package:convertouch/model/item_type.dart';
import 'package:convertouch/presenter/events/base_event.dart';

class MenuItemsFetchEvent extends BlocEvent {
  const MenuItemsFetchEvent(this.itemType);

  final ItemType itemType;

  @override
  List<Object> get props => [itemType];

  @override
  String toString() =>
      'MenuItemsFetchEvent { itemType: $itemType }';
}
