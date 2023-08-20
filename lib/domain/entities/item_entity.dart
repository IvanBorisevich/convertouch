import 'package:convertouch/domain/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ItemEntity extends Equatable {
  const ItemEntity({
    required this.itemType
  });

  final ItemType itemType;
}

abstract class ItemModelWithIdName extends ItemEntity {
  const ItemModelWithIdName({
    required this.id,
    required this.name,
    required ItemType itemType
  }) : super(itemType: itemType);

  final int id;
  final String name;
}