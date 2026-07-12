import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamSetModel extends IdNameSearchableItemModel {
  final bool mandatory;
  final int groupId;
  final String? iconName;

  const ConversionParamSetModel({
    super.id,
    required super.name,
    this.mandatory = false,
    required this.groupId,
    super.nameMatch,
    this.iconName,
  }) : super(itemType: ItemType.conversionParamSet);

  @override
  List<Object?> get props => [
        name,
        mandatory,
        groupId,
        nameMatch,
        itemType,
        iconName,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "id": id,
      "name": name,
      "iconName": iconName,
      "mandatory": mandatory,
      "groupId": groupId,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
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
      iconName: json["iconName"],
    );
  }

  ConversionParamSetModel copyWith({
    String? name,
    bool? mandatory,
    int? groupId,
    ItemSearchMatch? nameMatch,
    String? iconName,
  }) {
    return ConversionParamSetModel(
      id: id,
      name: name ?? this.name,
      mandatory: mandatory ?? this.mandatory,
      groupId: groupId ?? this.groupId,
      nameMatch: nameMatch ?? this.nameMatch,
      iconName: iconName ?? this.iconName,
    );
  }

  @override
  String toString() {
    return 'ParamSet{$id, $name}';
  }
}
