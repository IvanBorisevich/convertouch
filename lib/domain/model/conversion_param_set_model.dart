import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamSetModel extends IdNameItemModel {
  final bool mandatory;
  final int groupId;

  const ConversionParamSetModel({
    super.id,
    required super.name,
    this.mandatory = false,
    required this.groupId,
  }) : super(itemType: ItemType.conversionParamSet);

  @override
  List<Object?> get props => [
        name,
        mandatory,
        groupId,
        itemType,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "mandatory": mandatory,
      "groupId": groupId,
    };
  }

  static ConversionParamSetModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetModel(
      id: json["id"] ?? -1,
      name: json["name"],
      mandatory: json["mandatory"],
      groupId: json["groupId"],
    );
  }
}
