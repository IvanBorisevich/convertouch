import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class MenuItemsState extends BlocState {
  const MenuItemsState({required this.items});

  final List<ItemModel> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() {
    return 'MenuItemsState{'
        'items: $items}';
  }
}
