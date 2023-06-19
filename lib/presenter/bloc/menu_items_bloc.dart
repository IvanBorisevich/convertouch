import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/item_type.dart';
import 'package:convertouch/presenter/events/base_event.dart';
import 'package:convertouch/presenter/events/menu_items_fetch_event.dart';
import 'package:convertouch/presenter/states/menu_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItemsBloc extends Bloc<BlocEvent, MenuItemsState> {
  MenuItemsBloc() : super(const MenuItemsState(items: []));

  List<ItemModel> _items = [];

  List<ItemModel> get items => _items;

  @override
  Stream<MenuItemsState> mapEventToState(BlocEvent event) async* {
    if (event is MenuItemsFetchEvent) {
      _items = _getItems(event.itemType);
      yield MenuItemsState(items: _items);
    }
  }

  final List<UnitModel> _unitItems = const [
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'mm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'mm3'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'mm4'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square2 g uygtyfty tyf tyf ygf tyfyt t', 'km/h'),
    UnitModel(3, 'Centimeter Square hhhh hhhhhhhh', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
  ];

  final List<UnitGroupModel> _unitGroupItems = const [
    UnitGroupModel(1, 'Length'),
    UnitGroupModel(2, 'Area'),
    UnitGroupModel(3, 'Volume'),
    UnitGroupModel(4, 'Speed'),
    UnitGroupModel(5, 'Mass'),
    UnitGroupModel(6, 'Currency'),
    UnitGroupModel(7, 'Temperature'),
    UnitGroupModel(8, 'Numeral System'),
    UnitGroupModel(9, 'Length1 ehuefuhe uehfuehufhe fheufh'),
    UnitGroupModel(10, 'Length1dsdsdsdsddsddsdsdsssd'),
    UnitGroupModel(11, 'Len dd dd'),
    UnitGroupModel(12, 'Length11'),
    UnitGroupModel(13, 'Length'),
    UnitGroupModel(14, 'Length'),
    UnitGroupModel(15, 'Length'),
    UnitGroupModel(16, 'Length'),
    UnitGroupModel(17, 'Length'),
    UnitGroupModel(18, 'Length'),
    UnitGroupModel(19, 'Length'),
    UnitGroupModel(20, 'Length'),
    UnitGroupModel(21, 'Length'),
  ];

  List<ItemModel> _getItems(ItemType itemType) {
    switch (itemType) {
      case ItemType.unit:
        print("Fetch unit items1111");
        return _unitItems;
      case ItemType.unitGroup:
        print("Fetch unit group items1111");
        return _unitGroupItems;
    }
  }

  List<UnitModel> get unitItems {
    return _unitItems;
  }
}