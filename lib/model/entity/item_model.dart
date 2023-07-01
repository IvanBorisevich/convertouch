import 'package:convertouch/model/constant.dart';

abstract class ItemModel {
  const ItemModel(this._id, this._name, this._itemType);

  final int _id;
  final String _name;
  final ItemType _itemType;

  int get id => _id;

  String get name => _name;

  ItemType get itemType => _itemType;
}