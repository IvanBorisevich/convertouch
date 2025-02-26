import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/list_type.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionParamModel<T> extends IdNameItemModel {
  final bool calculable;
  final int? unitGroupId;
  final UnitModel? selectedUnit;
  final ConvertouchListType? listType;
  final int paramSetId;

  const ConversionParamModel({
    super.id,
    required super.name,
    this.unitGroupId,
    this.selectedUnit,
    this.calculable = false,
    this.listType,
    required this.paramSetId,
  }) : super(itemType: ItemType.conversionParam);

  const ConversionParamModel.unitBased({
    super.id,
    required super.name,
    this.calculable = false,
    required this.unitGroupId,
    required this.selectedUnit,
    required this.paramSetId,
  })  : listType = null,
        super(
          itemType: ItemType.conversionParam,
        );

  factory ConversionParamModel.listBased({
    int id = -1,
    required String name,
    bool calculable = false,
    required ConvertouchListType listType,
    required int paramSetId,
  }) {
    return ConversionParamModel(
      id: id,
      name: name,
      unitGroupId: null,
      selectedUnit: null,
      calculable: calculable,
      listType: listType,
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
        listType,
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
      "listType": listType?.val,
      "paramSetId": paramSetId,
    };
  }

  static ConversionParamModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamModel(
      id: json["id"] ?? -1,
      name: json["name"],
      calculable: json["calculable"],
      unitGroupId: json["unitGroupId"],
      selectedUnit: UnitModel.fromJson(json["selectedUnitId"]),
      listType: ConvertouchListType.valueOf(json["listType"]),
      paramSetId: json["paramSetId"],
    );
  }
}
