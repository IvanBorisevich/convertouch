import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitModel extends IdNameSearchableItemModel {
  static const UnitModel none = UnitModel._();

  final String code;
  final double? coefficient;
  final String? symbol;
  final int unitGroupId;
  final ConvertouchValueType valueType;
  final ConvertouchListType? listType;
  final ValueModel? minValue;
  final ValueModel? maxValue;
  final bool invertible;
  final ItemSearchMatch codeMatch;

  const UnitModel({
    super.id,
    required super.name,
    required this.code,
    this.coefficient,
    this.symbol,
    this.unitGroupId = -1,
    required this.valueType,
    this.listType,
    this.minValue,
    this.maxValue,
    this.invertible = true,
    super.nameMatch,
    this.codeMatch = ItemSearchMatch.none,
    super.oob,
  }) : super(
          itemType: ItemType.unit,
        );

  const UnitModel._()
      : this(
          name: "",
          code: "",
          valueType: ConvertouchValueType.decimalPositive,
        );

  UnitModel copyWith({
    int? id,
    String? name,
    String? code,
    double? coefficient,
    String? symbol,
    int? unitGroupId,
    ConvertouchValueType? valueType,
    ConvertouchListType? listType,
    ValueModel? minValue,
    ValueModel? maxValue,
    ItemSearchMatch? nameMatch,
    ItemSearchMatch? codeMatch,
    bool? invertible,
  }) {
    return UnitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      coefficient: coefficient ?? this.coefficient,
      symbol: symbol ?? this.symbol,
      valueType: valueType ?? this.valueType,
      listType: listType ?? this.listType,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      unitGroupId: unitGroupId ?? this.unitGroupId,
      invertible: this.invertible,
      nameMatch: nameMatch ?? this.nameMatch,
      codeMatch: codeMatch ?? this.codeMatch,
      oob: oob,
    );
  }

  @override
  String get itemName {
    return symbol != null ? "$name ($symbol)" : name;
  }

  bool get exists => this != none;

  bool get named => name.isNotEmpty;

  bool get unnamed => name.isEmpty;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "id": id,
      "name": name,
      "code": code,
      "coefficient": coefficient,
      "symbol": symbol,
      "unitGroupId": unitGroupId != -1 ? unitGroupId : null,
      "valueType": valueType.id,
      "listType": listType?.id,
      "minValue": minValue?.numVal,
      "maxValue": maxValue?.numVal,
      "invertible": invertible,
      "oob": oob,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static UnitModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UnitModel(
      id: json["id"] ?? -1,
      name: json["name"],
      code: json["code"],
      coefficient: json["coefficient"]?.toDouble(),
      symbol: json["symbol"],
      unitGroupId: json["unitGroupId"] ?? -1,
      valueType: ConvertouchValueType.valueOf(json["valueType"])!,
      listType: ConvertouchListType.valueOf(json["listType"]),
      minValue: json["minValue"] != null
          ? ValueModel.numeric(json["minValue"])
          : null,
      maxValue: json["maxValue"] != null
          ? ValueModel.numeric(json["maxValue"])
          : null,
      invertible: json["invertible"] ?? true,
      oob: json["oob"] == true,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        coefficient,
        code,
        symbol,
        unitGroupId,
        valueType,
        listType,
        minValue,
        maxValue,
        invertible,
        nameMatch,
        codeMatch,
        oob,
      ];

  @override
  String toString() {
    if (!exists) {
      return "UnitModel.none";
    }
    return 'UnitModel{'
        'id: $id, '
        'name: $name, '
        'code: $code, '
        'coefficient: $coefficient, '
        'symbol: $symbol, '
        'unitGroupId: $unitGroupId, '
        'valueType: $valueType, '
        'minValue: $minValue, '
        'maxValue: $maxValue, '
        'listType: $listType, '
        'invertible: $invertible}';
  }
}
