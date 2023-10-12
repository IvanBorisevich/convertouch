import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ItemModel extends Equatable {
  const ItemModel({
    required this.itemType
  });

  final ItemType itemType;
}

abstract class IdNameItemModel extends ItemModel {
  const IdNameItemModel({
    this.id,
    required this.name,
    required ItemType itemType
  }) : super(itemType: itemType);

  final int? id;
  final String name;
}