import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ConversionItemModel extends ItemModel {
  final UnitModel unit;
  final ValueModel value;
  final ValueModel defaultValue;

  const ConversionItemModel({
    required this.unit,
    required this.value,
    required this.defaultValue,
  }) : super(
          itemType: ItemType.unitValue,
        );

  ConversionItemModel.fromStrValue({
    required UnitModel unit,
    required String strValue,
    String defaultValue = "1",
  }) : this(
          unit: unit,
          value: ValueModel(strValue: strValue),
          defaultValue: ValueModel(strValue: defaultValue),
        );

  @override
  List<Object?> get props => [
    itemType,
    unit,
    value,
    defaultValue,
  ];

  @override
  String toString() {
    return 'ConversionItemModel{$value ${unit.name}, '
        'default: $defaultValue ${unit.name}';
  }
}
