import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class UnitGroupModel extends IdNameItemModel {
  const UnitGroupModel({
    int? id,
    required String name,
    this.iconName,
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

  final String? iconName;

  @override
  String toString() {
    return 'UnitGroupModel{$name}';
  }
}
