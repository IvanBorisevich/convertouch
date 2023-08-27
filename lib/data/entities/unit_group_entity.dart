import 'package:convertouch/data/entities/item_entity.dart';
import 'package:convertouch/domain/constants.dart';

class UnitGroupEntity extends ItemEntity {
  final String iconName;

  const UnitGroupEntity({
    required int id,
    required String name,
    this.iconName = unitGroupDefaultIconName,
  }) : super(
    id: id,
    name: name,
  );

  @override
  List<Object> get props => [id, name, iconName];
}
