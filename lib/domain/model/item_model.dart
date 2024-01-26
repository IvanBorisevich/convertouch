import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ItemModel extends Equatable {
  final ItemType itemType;
  final bool oob;

  const ItemModel({
    required this.itemType,
    this.oob = false,
  });
}

abstract class IdNameItemModel extends ItemModel {
  final int? id;
  final String name;

  const IdNameItemModel({
    this.id,
    required this.name,
    required super.itemType,
    super.oob,
  });
}