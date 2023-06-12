import 'package:convertouch/model/item_type.dart';

abstract class ItemModel {
  ItemModel(this._id, this._name, this._itemType);

  final int _id;
  final String _name;
  final ItemType _itemType;

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }

  ItemType get itemType {
    return _itemType;
  }
}