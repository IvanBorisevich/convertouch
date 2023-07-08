import 'package:convertouch/model/constant.dart';

abstract class ItemModel {
  const ItemModel(this.id, this.name, this.itemType);

  final int id;
  final String name;
  final ItemType itemType;
}