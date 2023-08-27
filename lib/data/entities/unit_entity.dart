import 'package:convertouch/data/entities/item_entity.dart';

class UnitEntity extends ItemEntity {
  final String abbreviation;
  final double coefficient;
  final int unitGroupId;

  const UnitEntity({
    required int id,
    required String name,
    required this.abbreviation,
    required this.coefficient,
    required this.unitGroupId,
  }) : super(
    id: id,
    name: name,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    abbreviation,
    coefficient,
    unitGroupId,
  ];


}