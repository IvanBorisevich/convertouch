import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitGroupModel extends IdNameSearchableItemModel {
  static const UnitGroupModel none = UnitGroupModel._();

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
    required this.valueType,
    this.minValue = ValueModel.empty,
    this.maxValue = ValueModel.empty,
    super.nameMatch,
    super.oob,
  }) : super(
          itemType: ItemType.unitGroup,
        );

  UnitGroupModel copyWith({
    int? id,
    String? name,
    String? iconName,
    ConvertouchValueType? valueType,
    ValueModel? minValue,
    ValueModel? maxValue,
    ItemSearchMatch? nameMatch,
  }) {
    return UnitGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      conversionType: conversionType,
      refreshable: refreshable,
      valueType: valueType ?? this.valueType,
      minValue: minValue?.isNotEmpty == true ? minValue! : this.minValue,
      maxValue: maxValue?.isNotEmpty == true ? maxValue! : this.maxValue,
      nameMatch: nameMatch ?? this.nameMatch,
      oob: oob,
    );
  }

  const UnitGroupModel._()
      : this(
          name: "",
          valueType: ConvertouchValueType.decimalPositive,
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
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "id": id,
      "name": name,
      "iconName": iconName,
      "conversionType": conversionType.value,
      "refreshable": refreshable,
      "valueType": valueType.id,
      "minValue": minValue.numVal,
      "maxValue": maxValue.numVal,
      "oob": oob,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
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
      valueType: ConvertouchValueType.valueOf(json["valueType"])!,
      minValue: ValueModel.numeric(json["minValue"]),
      maxValue: ValueModel.numeric(json["maxValue"]),
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
