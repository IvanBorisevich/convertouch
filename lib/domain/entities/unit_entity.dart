import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/item_entity.dart';

class UnitEntity extends ItemModelWithIdName {
  const UnitEntity({
    int id = 0,
    required String name,
    this.coefficient = 1,
    required this.abbreviation
  }) : super(id: id, name: name, itemType: ItemType.unit);

  @override
  List<Object> get props => [id, name, itemType, coefficient, abbreviation];

  final double coefficient;
  final String abbreviation;

  @override
  String toString() {
    return 'UnitModel{id: $id, name: $name, abbreviation: $abbreviation}';
  }
}
