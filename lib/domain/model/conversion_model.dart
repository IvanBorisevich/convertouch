import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

const int minimumNumberOfConversionItems = 2;

class ConversionModel extends IdNameItemModel {
  static const none = ConversionModel.noItems(
    id: -1,
    unitGroup: UnitGroupModel.none,
    params: null,
  );

  final UnitGroupModel unitGroup;
  final ConversionUnitValueModel? srcUnitValue;
  final ConversionParamSetValueBulkModel? params;
  final List<ConversionUnitValueModel> convertedUnitValues;

  const ConversionModel({
    super.id = -1,
    super.name = "",
    this.unitGroup = UnitGroupModel.none,
    this.srcUnitValue,
    this.params,
    this.convertedUnitValues = const [],
  }) : super(
          itemType: ItemType.conversion,
        );

  const ConversionModel.noItems({
    required int id,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueBulkModel? params,
  }) : this(
          id: id,
          unitGroup: unitGroup,
          params: params,
        );

  ConversionModel copyWith({
    int? id,
    String? name,
    UnitGroupModel? unitGroup,
    ConversionUnitValueModel? srcUnitValue,
    List<ConversionUnitValueModel>? convertedUnitValues,
    ConversionParamSetValueBulkModel? params,
  }) {
    return ConversionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unitGroup: unitGroup ?? this.unitGroup,
      srcUnitValue: srcUnitValue ?? this.srcUnitValue,
      convertedUnitValues: convertedUnitValues ?? this.convertedUnitValues,
      params: params ?? this.params,
    );
  }

  @override
  Map<String, dynamic> toJson({
    bool removeNulls = true,
    bool saveListValues = false,
  }) {
    var result = {
      "id": id,
      "unitGroup": unitGroup.toJson(removeNulls: removeNulls),
      "sourceItem": srcUnitValue?.toJson(
        removeNulls: removeNulls,
        saveListValues: saveListValues,
      ),
      "params": params?.toJson(saveListValues: saveListValues),
      "targetItems": convertedUnitValues
          .map(
            (item) => item.toJson(
              removeNulls: removeNulls,
              saveListValues: saveListValues,
            ),
          )
          .toList(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ConversionModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ConversionModel(
      id: json["id"] ?? -1,
      unitGroup:
          UnitGroupModel.fromJson(json["unitGroup"]) ?? UnitGroupModel.none,
      srcUnitValue: ConversionUnitValueModel.fromJson(json["sourceItem"]),
      params: ConversionParamSetValueBulkModel.fromJson(json["params"]),
      convertedUnitValues: (json["targetItems"] as List)
          .map((unitMap) => ConversionUnitValueModel.fromJson(unitMap)!)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        unitGroup,
        srcUnitValue,
        params,
        convertedUnitValues,
      ];

  bool get hasUnitValues => convertedUnitValues.isNotEmpty;

  bool get hasAddedParams =>
      params != null && params!.paramSetValues.isNotEmpty;

  bool get hasValuesOrAddedParams => hasUnitValues || hasAddedParams;

  bool get exists => this != none;

  bool get readyToRefresh => areParamsFilled(params?.active);

  @override
  String toString() {
    return 'Conversion{\n'
        'id: $id,\n'
        'group: ${unitGroup.name} (id = ${unitGroup.id}),\n'
        'params: ${params ?? '-'},\n'
        'src: $srcUnitValue,\n'
        'items: [\n\t${convertedUnitValues.join("\n\t")}\n],\n'
        'readyToRefresh: $readyToRefresh\n}';
  }
}
