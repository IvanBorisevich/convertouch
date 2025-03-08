import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionParamModel extends IdNameItemModel {
  final int? unitGroupId;
  final UnitModel? selectedUnit;
  final bool calculable;
  final ConvertouchValueType valueType;
  final int paramSetId;

  const ConversionParamModel._({
    super.id,
    required super.name,
    this.unitGroupId,
    this.selectedUnit,
    this.calculable = false,
    required this.valueType,
    required this.paramSetId,
  }) : super(itemType: ItemType.conversionParam);

  factory ConversionParamModel.unitBased({
    int id = -1,
    required String name,
    bool calculable = false,
    required int unitGroupId,
    required UnitModel selectedUnit,
    required int paramSetId,
  }) {
    return ConversionParamModel._(
      id: id,
      name: name,
      calculable: calculable,
      unitGroupId: unitGroupId,
      selectedUnit: selectedUnit,
      valueType: selectedUnit.valueType,
      paramSetId: paramSetId,
    );
  }

  factory ConversionParamModel.listBased({
    int id = -1,
    required String name,
    bool calculable = false,
    required ConvertouchListValueType listValueType,
    required int paramSetId,
  }) {
    return ConversionParamModel._(
      id: id,
      name: name,
      calculable: calculable,
      valueType: ConvertouchValueType.byListType(listValueType),
      paramSetId: paramSetId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        unitGroupId,
        selectedUnit,
        calculable,
        paramSetId,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "unitGroupId": unitGroupId,
      "selectedUnit": selectedUnit?.toJson(),
      "calculable": calculable,
      "listValueType": valueType.listValueType.val,
      "paramSetId": paramSetId,
    };
  }

  static ConversionParamModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    if (json["selectedUnitId"] != null) {
      return ConversionParamModel.unitBased(
        id: json["id"] ?? -1,
        name: json["name"],
        calculable: json["calculable"],
        unitGroupId: json["unitGroupId"],
        selectedUnit: UnitModel.fromJson(json["selectedUnitId"])!,
        paramSetId: json["paramSetId"],
      );
    } else {
      return ConversionParamModel.listBased(
        id: json["id"] ?? -1,
        name: json["name"],
        calculable: json["calculable"],
        listValueType: ConvertouchListValueType.valueOf(json["valueType"]),
        paramSetId: json["paramSetId"],
      );
    }
  }
}
