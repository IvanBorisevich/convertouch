import 'package:convertouch/domain/entities/item_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ItemModel<EntityType extends ItemEntity> extends Equatable {
  final int id;
  final String name;

  const ItemModel({
    required this.id,
    required this.name,
  });

  EntityType toEntity();
}