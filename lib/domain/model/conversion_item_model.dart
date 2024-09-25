import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

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

  ConversionItemModel.coalesce(
    ConversionItemModel? savedModel, {
    UnitModel? unit,
    ValueModel? value,
    ValueModel? defaultValue,
  }) : this(
          unit: ObjectUtils.coalesce(
                what: savedModel?.unit,
                patchWith: unit,
              ) ??
              savedModel?.unit ??
              UnitModel.none,
          value: ObjectUtils.coalesce(
                what: savedModel?.value,
                patchWith: value,
              ) ??
              savedModel?.value ??
              ValueModel.none,
          defaultValue: ObjectUtils.coalesce(
                what: savedModel?.defaultValue,
                patchWith: defaultValue,
              ) ??
              savedModel?.defaultValue ??
              ValueModel.none,
        );

  bool get valueExists => value.exists && defaultValue.exists;

  bool get isUndefined =>
      (!value.isDefined || !value.exists) && !defaultValue.isDefined;

  Map<String, dynamic> toJson() {
    return {
      "unit": unit.toJson(),
      "value": value.toJson(),
      "defaultValue": defaultValue.toJson(),
    };
  }

  static ConversionItemModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionItemModel(
      unit: UnitModel.fromJson(json["unit"])!,
      value: ValueModel.fromJson(json["value"]) ?? ValueModel.none,
      defaultValue:
          ValueModel.fromJson(json["defaultValue"]) ?? ValueModel.none,
    );
  }

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
