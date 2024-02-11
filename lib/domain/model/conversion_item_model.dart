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
    this.defaultValue = ValueModel.one,
  }) : super(
          itemType: ItemType.conversionItem,
        );

  ConversionItemModel.fromStrValue({
    required UnitModel unit,
    String strValue = "",
  }) : this(
          unit: unit,
          value: ValueModel.ofString(strValue),
          defaultValue: ValueModel.one,
        );

  const ConversionItemModel.fromUnit({
    required UnitModel unit,
  }) : this(
          unit: unit,
          value: ValueModel.none,
          defaultValue: ValueModel.one,
        );

  bool get empty => value.empty && defaultValue.empty;

  bool get notEmpty => !empty;

  @override
  List<Object?> get props => [
        itemType,
        unit,
        value,
        defaultValue,
      ];

  @override
  String toString() {
    return 'ConversionItemModel{'
        'unit id: ${unit.id}, '
        'name: ${unit.name}, '
        'coefficient: ${unit.coefficient}, '
        'value: $value, '
        'default: $defaultValue';
  }
}
