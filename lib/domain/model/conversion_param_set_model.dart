import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ConversionParamSetModel extends IdNameSearchableItemModel {
  final bool mandatory;
  final int groupId;

  const ConversionParamSetModel({
    super.id,
    required super.name,
    this.mandatory = false,
    required this.groupId,
    super.nameMatch,
  }) : super(itemType: ItemType.conversionParamSet);

  @override
  List<Object?> get props => [
        name,
        mandatory,
        groupId,
        nameMatch,
        itemType,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
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

  ConversionParamSetModel copyWith({
    String? name,
    bool? mandatory,
    int? groupId,
    ItemSearchMatch? nameMatch,
  }) {
    return ConversionParamSetModel(
      id: id,
      name: name ?? this.name,
      mandatory: mandatory ?? this.mandatory,
      groupId: groupId ?? this.groupId,
      nameMatch: nameMatch ?? this.nameMatch,
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetModel{'
        'id: $id, '
        'name: $name, '
        'mandatory: $mandatory, '
        'groupId: $groupId}';
  }
}
