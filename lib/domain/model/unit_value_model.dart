import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitValueModel extends ItemModel {
  final UnitModel unit;
  final ValueModel value;

  const UnitValueModel({
    required this.unit,
    required this.value,
  }) : super(
          itemType: ItemType.unitValue,
        );

  UnitValueModel.fromStrValue({
    required UnitModel unit,
    required String strValue,
  }) : this(
          unit: unit,
          value: ValueModel(strValue: strValue),
        );

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
