import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class UnitModel extends IdNameItemModel {
  const UnitModel({
    int? id,
    required String name,
    this.coefficient = 1,
    required this.abbreviation,
    required this.unitGroupId,
  }) : super(
          id: id,
          name: name,
          itemType: ItemType.unit,
        );

  final double coefficient;
  final String abbreviation;
  final int unitGroupId;

  @override
  List<Object?> get props => [
    id,
    name,
    itemType,
    coefficient,
    abbreviation,
    unitGroupId,
  ];

  @override
  String toString() {
    return 'UnitModel{'
        'id: $id, '
        'name: $name, '
        'coefficient: $coefficient, '
        'abbreviation: $abbreviation, '
        'unitGroupId: $unitGroupId}';
  }
}
