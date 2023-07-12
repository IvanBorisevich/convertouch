import 'package:convertouch/model/constant.dart';

abstract class ItemModel {
  const ItemModel(this.itemType);

  final ItemType itemType;
}

abstract class ItemModelWithIdName extends ItemModel {
  const ItemModelWithIdName(this.id, this.name, ItemType itemType)
      : super(itemType);

  final int id;
  final String name;
}