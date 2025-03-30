import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamModel extends IdNameItemModel {
  final int? unitGroupId;
  final bool calculable;
  final ConvertouchValueType valueType;
  final int paramSetId;

  const ConversionParamModel({
    super.id,
    required super.name,
    this.unitGroupId,
    this.calculable = false,
    required this.valueType,
    required this.paramSetId,
  }) : super(itemType: ItemType.conversionParam);

  const ConversionParamModel.unitBased({
    super.id,
    required super.name,
    this.calculable = false,
    required this.unitGroupId,
    required this.valueType,
    required this.paramSetId,
  })  : assert(unitGroupId != null),
        super(itemType: ItemType.conversionParam);

  factory ConversionParamModel.listBased({
    int id = -1,
    required String name,
    bool calculable = false,
    required ConvertouchListType listValueType,
    required int paramSetId,
  }) {
    return ConversionParamModel(
      id: id,
      name: name,
      calculable: calculable,
      unitGroupId: null,
      valueType: ConvertouchValueType.byListType(listValueType),
      paramSetId: paramSetId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        unitGroupId,
        calculable,
        paramSetId,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "unitGroupId": unitGroupId,
      "calculable": calculable,
      "valueType": valueType.val,
      "paramSetId": paramSetId,
    };
  }

  static ConversionParamModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    if (json["unitGroupId"] != null) {
      return ConversionParamModel.unitBased(
        id: json["id"] ?? -1,
        name: json["name"],
        calculable: json["calculable"],
        unitGroupId: json["unitGroupId"],
        valueType: ConvertouchValueType.valueOf(json["valueType"])!,
        paramSetId: json["paramSetId"],
      );
    } else {
      return ConversionParamModel.listBased(
        id: json["id"] ?? -1,
        name: json["name"],
        calculable: json["calculable"],
        listValueType: ConvertouchListType.valueOf(json["valueType"]),
        paramSetId: json["paramSetId"],
      );
    }
  }
}
