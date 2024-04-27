import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class UnitGroupModel extends IdNameItemModel {
  static const UnitGroupModel none = UnitGroupModel._();

  final String? iconName;
  final ConversionType conversionType;
  final bool refreshable;
  final ConvertouchValueType valueType;
  final double? minValue;
  final double? maxValue;

  const UnitGroupModel({
    super.id,
    required super.name,
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
    required this.valueType,
    this.minValue,
    this.maxValue,
    super.oob,
    super.itemType = ItemType.unitGroup,
  });

  UnitGroupModel.coalesce(
    UnitGroupModel savedUnitGroup, {
    int? id,
    String? name,
    String? iconName,
    ConvertouchValueType? valueType,
    double? minValue,
    double? maxValue,
  }) : this(
          id: ObjectUtils.coalesce(
            what: savedUnitGroup.id,
            patchWith: id,
          ),
          name: ObjectUtils.coalesce(
                what: savedUnitGroup.name,
                patchWith: name,
              ) ??
              "",
          iconName: ObjectUtils.coalesce(
            what: savedUnitGroup.iconName,
            patchWith: iconName,
          ),
          conversionType: savedUnitGroup.conversionType,
          refreshable: savedUnitGroup.refreshable,
          valueType: valueType ?? savedUnitGroup.valueType,
          minValue: ObjectUtils.coalesce(
            what: savedUnitGroup.minValue,
            patchWith: minValue,
          ),
          maxValue: ObjectUtils.coalesce(
            what: savedUnitGroup.maxValue,
            patchWith: maxValue,
          ),
          oob: savedUnitGroup.oob,
        );

  const UnitGroupModel._()
      : this(
          name: "",
          valueType: ConvertouchValueType.text,
        );

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        iconName,
        conversionType,
        refreshable,
        oob,
      ];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "iconName": iconName,
      "conversionType": conversionType.value,
      "refreshable": refreshable,
      "valueType": valueType.val,
      "minValue": minValue,
      "maxValue": maxValue,
      "oob": oob,
    };
  }

  static UnitGroupModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UnitGroupModel(
      id: json["id"],
      name: json["name"],
      iconName: json["iconName"],
      conversionType: ConversionType.valueOf(json["conversionType"]),
      refreshable: json["refreshable"],
      valueType: ConvertouchValueType.valueOf(json["valueType"]) ??
          ConvertouchValueType.text,
      minValue: json["minValue"],
      maxValue: json["maxValue"],
      oob: json["oob"],
    );
  }

  @override
  String toString() {
    return 'UnitGroupModel{$name}';
  }
}
