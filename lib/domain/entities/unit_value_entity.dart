import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/item_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';

class UnitValueEntity extends ItemEntity {
  const UnitValueEntity({
    required this.unit,
    required this.value
  }) : super(itemType: ItemType.unitValue);

  final UnitEntity unit;
  final String value;

  @override
  List<Object> get props => [itemType, unit, value];

  @override
  String toString() {
    return 'UnitValueModel{unit: $unit, value: $value}';
  }
}