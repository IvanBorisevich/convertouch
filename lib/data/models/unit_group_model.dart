import 'package:convertouch/data/models/item_model.dart';
import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';

class UnitGroupModel extends ItemModel {
  final String iconName;

  const UnitGroupModel({
    required int id,
    required String name,
    this.iconName = unitGroupDefaultIconName,
  }) : super(
    id: id,
    name: name,
  );

  @override
  List<Object> get props => [id, name, iconName];

  @override
  UnitGroupEntity toEntity() => UnitGroupEntity(
    id: id,
    name: name,
    iconName: iconName,
  );
}
