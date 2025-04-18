import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionParamModel extends IdNameItemModel {
  final int? unitGroupId;
  final bool calculable;
  final ConvertouchValueType valueType;
  final ConvertouchListType? listType;
  final UnitModel? defaultUnit;
  final int paramSetId;

  const ConversionParamModel({
    super.id,
    required super.name,
    this.unitGroupId,
    this.calculable = false,
    required this.valueType,
    this.listType,
    this.defaultUnit,
    required this.paramSetId,
  }) : super(itemType: ItemType.conversionParam);

  @override
  List<Object?> get props => [
        id,
        name,
        unitGroupId,
        calculable,
        valueType,
        listType,
        defaultUnit,
        paramSetId,
      ];

  ConversionParamModel copyWith({
    int? id,
    String? name,
    int? unitGroupId,
    bool? calculable,
    ConvertouchValueType? valueType,
    ConvertouchListType? listType,
    UnitModel? defaultUnit,
    int? paramSetId,
  }) {
    return ConversionParamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unitGroupId: unitGroupId ?? this.unitGroupId,
      calculable: calculable ?? this.calculable,
      valueType: valueType ?? this.valueType,
      listType: listType ?? this.listType,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      paramSetId: paramSetId ?? this.paramSetId,
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "id": id,
      "name": name,
      "unitGroupId": unitGroupId,
      "calculable": calculable,
      "valueType": valueType.id,
      "listType": listType?.id,
      "defaultUnit": defaultUnit?.toJson(removeNulls: removeNulls),
      "paramSetId": paramSetId,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ConversionParamModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ConversionParamModel(
      id: json["id"] ?? -1,
      name: json["name"],
      valueType: ConvertouchValueType.valueOf(json["valueType"])!,
      listType: ConvertouchListType.valueOf(json["listType"]),
      paramSetId: json["paramSetId"],
      calculable: json["calculable"],
      unitGroupId: json["unitGroupId"],
      defaultUnit: UnitModel.fromJson(json["defaultUnit"]),
    );
  }

  @override
  String toString() {
    return 'ConversionParamModel{'
        'id: $id, '
        'name: $name, '
        'unitGroupId: $unitGroupId, '
        'calculable: $calculable, '
        'valueType: $valueType, '
        'listType: $listType, '
        'defaultUnit: $defaultUnit, '
        'paramSetId: $paramSetId}';
  }
}
