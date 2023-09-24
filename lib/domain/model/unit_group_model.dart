import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class UnitGroupModel extends IdNameItemModel {
  const UnitGroupModel({
    int? id,
    required String name,
    this.iconName = unitGroupDefaultIconName,
  }) : super(
    id: id,
    name: name,
    itemType: ItemType.unitGroup,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    itemType,
    iconName,
  ];

  final String iconName;

  @override
  String toString() {
    return 'UnitGroupModel{'
        'id: $id, '
        'name: $name, '
        'iconName: $iconName}';
  }
}
