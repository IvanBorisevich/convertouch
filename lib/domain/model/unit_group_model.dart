import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitGroupModel extends IdNameSearchableItemModel {
  static const UnitGroupModel none = UnitGroupModel._();
  static const ConvertouchValueType defaultValueType =
      ConvertouchValueType.decimal;

  final String? iconName;
  final ConversionType conversionType;
  final bool refreshable;
  final ConvertouchValueType valueType;
  final ValueModel minValue;
  final ValueModel maxValue;

  const UnitGroupModel({
    super.id,
    required super.name,
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
    this.valueType = defaultValueType,
    this.minValue = ValueModel.none,
    this.maxValue = ValueModel.none,
    super.nameMatch,
    super.oob,
  }) : super(
          itemType: ItemType.unitGroup,
        );

  UnitGroupModel.coalesce(
    UnitGroupModel saved, {
    int? id,
    String? name,
    String? iconName,
    ConvertouchValueType? valueType,
    ValueModel? minValue,
    ValueModel? maxValue,
    ItemSearchMatch? nameMatch,
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          iconName: iconName ?? saved.iconName,
          conversionType: saved.conversionType,
          refreshable: saved.refreshable,
          valueType: valueType ?? saved.valueType,
          minValue: minValue?.exists == true ? minValue! : saved.minValue,
          maxValue: maxValue?.exists == true ? maxValue! : saved.maxValue,
          nameMatch: nameMatch ?? saved.nameMatch,
          oob: saved.oob,
        );

  const UnitGroupModel._()
      : this(
          name: "",
          valueType: defaultValueType,
        );

  bool get exists => this != none;

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        iconName,
        conversionType,
        refreshable,
        valueType,
        minValue,
        maxValue,
        nameMatch,
        oob,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "iconName": iconName,
      "conversionType": conversionType.value,
      "refreshable": refreshable,
      "valueType": valueType.val,
      "minValue": minValue.num,
      "maxValue": maxValue.num,
      "oob": oob,
    };
  }

  static UnitGroupModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UnitGroupModel(
      id: json["id"] ?? -1,
      name: json["name"],
      iconName: json["iconName"],
      conversionType: ConversionType.valueOf(json["conversionType"]),
      refreshable: json["refreshable"],
      valueType:
          ConvertouchValueType.valueOf(json["valueType"]) ?? defaultValueType,
      minValue: ValueModel.ofDouble(json["minValue"]),
      maxValue: ValueModel.ofDouble(json["maxValue"]),
      oob: json["oob"],
    );
  }

  @override
  String toString() {
    if (!exists) {
      return "UnitGroupModel.none";
    }
    return 'UnitGroupModel{'
        'id: $id, '
        'name: $name, '
        'iconName: $iconName, '
        'conversionType: $conversionType, '
        'refreshable: $refreshable, '
        'valueType: $valueType, '
        'minValue: $minValue, '
        'maxValue: $maxValue, '
        'nameMatch: $nameMatch}';
  }
}
