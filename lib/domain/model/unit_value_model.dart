import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class UnitValueModel extends ItemModel {
  const UnitValueModel({
    required this.unit,
    required this.value,
  }) : super(
    itemType: ItemType.unitValue,
  );

  final UnitModel unit;
  final double? value;

  @override
  List<Object?> get props => [
    itemType,
    unit,
    value,
  ];

  @override
  String toString() {
    return 'UnitValueModel{$value ${unit.name}}';
  }
}
