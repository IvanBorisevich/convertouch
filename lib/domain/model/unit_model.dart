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
  final ValueModel minValue;
  final ValueModel maxValue;
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
    this.minValue = ValueModel.empty,
    this.maxValue = ValueModel.empty,
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

  UnitModel.coalesce(
    UnitModel saved, {
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
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          code: code ?? saved.code,
          coefficient: coefficient ?? saved.coefficient,
          symbol: symbol ?? saved.symbol,
          valueType: valueType ?? saved.valueType,
          listType: listType ?? saved.listType,
          minValue: minValue?.isNotEmpty == true ? minValue! : saved.minValue,
          maxValue: maxValue?.isNotEmpty == true ? maxValue! : saved.maxValue,
          unitGroupId: unitGroupId ?? saved.unitGroupId,
          invertible: saved.invertible,
          nameMatch: nameMatch ?? saved.nameMatch,
          codeMatch: codeMatch ?? saved.codeMatch,
          oob: saved.oob,
        );

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
      "minValue": minValue.numVal,
      "maxValue": maxValue.numVal,
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
      coefficient: json["coefficient"],
      symbol: json["symbol"],
      unitGroupId: json["unitGroupId"] ?? -1,
      valueType: ConvertouchValueType.valueOf(json["valueType"])!,
      listType: ConvertouchListType.valueOf(json["listType"]),
      minValue: ValueModel.numeric(json["minValue"]),
      maxValue: ValueModel.numeric(json["maxValue"]),
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
        'invertible: $invertible, '
        'nameMatch: $nameMatch, '
        'codeMatch: $codeMatch}';
  }
}
