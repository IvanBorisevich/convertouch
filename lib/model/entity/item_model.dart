import 'package:convertouch/model/constant.dart';

abstract class ItemModel {
  const ItemModel({
    required this.itemType
  });

  final ItemType itemType;
}

abstract class ItemModelWithIdName extends ItemModel {
  const ItemModelWithIdName({
    required this.id,
    required this.name,
    required ItemType itemType
  }) : super(itemType: itemType);

  final int id;
  final String name;
}