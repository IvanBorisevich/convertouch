import 'package:equatable/equatable.dart';

abstract class ItemEntity extends Equatable {
  final int id;
  final String name;

  const ItemEntity({
    required this.id,
    required this.name,
  });
}