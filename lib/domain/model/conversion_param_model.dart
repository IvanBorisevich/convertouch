import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamModel<T> extends IdNameItemModel {
  final String? unitGroupName;
  final bool calculable;
  final List<T>? possibleValues;
  final List<String>? possibleUnitCodes;

  const ConversionParamModel({
    required super.name,
    this.unitGroupName,
    this.calculable = false,
    this.possibleValues,
    this.possibleUnitCodes,
  }) : super(itemType: ItemType.conversionParam);

  const ConversionParamModel.unitBased({
    required super.name,
    required this.unitGroupName,
    this.calculable = false,
    this.possibleUnitCodes,
  })  : possibleValues = null,
        super(
          itemType: ItemType.conversionParam,
        );

  const ConversionParamModel.listBased({
    required super.name,
    this.calculable = false,
    required this.possibleValues,
  })  : unitGroupName = null,
        possibleUnitCodes = null,
        super(
          itemType: ItemType.conversionParam,
        );

  @override
  List<Object?> get props => [
        name,
        unitGroupName,
        calculable,
        possibleValues,
        possibleUnitCodes,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "unitGroupName": unitGroupName,
      "calculable": calculable,
      "possibleValues": possibleValues,
      "possibleUnitCodes": possibleUnitCodes,
    };
  }

  static ConversionParamModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamModel(
      name: json["name"],
      unitGroupName: json["unitGroupName"],
      calculable: json["calculable"],
      possibleValues: json["possibleValues"],
      possibleUnitCodes: json["possibleUnitCodes"],
    );
  }
}
