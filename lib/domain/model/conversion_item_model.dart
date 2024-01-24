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
    this.defaultValue = defaultValueModel,
  }) : super(
          itemType: ItemType.conversionItem,
        );

  ConversionItemModel.fromStrValue({
    required UnitModel unit,
    String strValue = "",
    String defaultValue = "1",
    String defaultScientificValue = "1",
  }) : this(
          unit: unit,
          value: ValueModel(
            strValue: strValue,
          ),
          defaultValue: ValueModel(
            strValue: defaultValue,
            scientificValue: defaultScientificValue,
          ),
        );

  const ConversionItemModel.fromUnit({
    required UnitModel unit,
  }) : this(
          unit: unit,
          value: const ValueModel(
            strValue: "",
          ),
          defaultValue: const ValueModel(
            strValue: "1",
            scientificValue: "1",
          ),
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
    return 'ConversionItemModel{'
        'name: ${unit.name}, '
        'value: $value, '
        'default: $defaultValue';
  }
}
