import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitModel extends IdNameItemModel {
  static const UnitModel none = UnitModel._();

  final String code;
  final double? coefficient;
  final String? symbol;
  final int unitGroupId;
  final ConvertouchValueType? valueType;
  final ValueModel? minValue;
  final ValueModel? maxValue;
  final bool invertible;

  const UnitModel({
    super.id,
    required super.name,
    required this.code,
    this.coefficient,
    this.symbol,
    this.unitGroupId = -1,
    this.valueType,
    this.minValue = ValueModel.none,
    this.maxValue = ValueModel.none,
    this.invertible = true,
    super.oob,
  }) : super(
          itemType: ItemType.unit,
        );

  const UnitModel._()
      : this(
          name: "",
          code: "",
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
    ValueModel? minValue,
    ValueModel? maxValue,
    bool? invertible,
  }) : this(
          id: id ?? saved.id,
          name: name ?? saved.name,
          code: code ?? saved.code,
          coefficient: coefficient ?? saved.coefficient,
          symbol: symbol ?? saved.symbol,
          valueType: valueType ?? saved.valueType,
          minValue: minValue?.exists == true ? minValue! : saved.minValue,
          maxValue: maxValue?.exists == true ? maxValue! : saved.maxValue,
          unitGroupId: unitGroupId ?? saved.unitGroupId,
          invertible: saved.invertible,
          oob: saved.oob,
        );

  bool get exists => this != none;

  bool get named => name.isNotEmpty;

  bool get unnamed => name.isEmpty;

  Map<String, dynamic> toJson() {
    var result = {
      "id": id,
      "name": name,
      "code": code,
      "coefficient": coefficient,
      "symbol": symbol,
      "unitGroupId": unitGroupId != -1 ? unitGroupId : null,
      "valueType": valueType?.val,
      "minValue": minValue?.num,
      "maxValue": maxValue?.num,
      "invertible": invertible,
      "oob": oob == true ? true : null,
    };

    result.removeWhere((key, value) => value == null);
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
      valueType: ConvertouchValueType.valueOf(json["valueType"]),
      minValue: ValueModel.ofDouble(json["minValue"]),
      maxValue: ValueModel.ofDouble(json["maxValue"]),
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
        'invertible: $invertible}';
  }
}
