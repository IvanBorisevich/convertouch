import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamSetModel extends IdNameItemModel {
  final bool mandatory;

  const ConversionParamSetModel({
    required super.name,
    this.mandatory = false,
  }) : super(itemType: ItemType.conversionParamSet);

  @override
  List<Object?> get props => [
        name,
        mandatory,
        itemType,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mandatory": mandatory,
    };
  }

  static ConversionParamSetModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetModel(
      name: json["name"],
      mandatory: json["mandatory"],
    );
  }
}
