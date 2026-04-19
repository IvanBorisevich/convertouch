import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class ListValueModel extends IdNameSearchableItemModel {
  static const ListValueModel none = ListValueModel(value: '');

  final String value;
  final String? alt;

  const ListValueModel({
    required this.value,
    this.alt,
  }) : super(
    id: -1,
    name: '',
    itemType: ItemType.listValue,
    oob: true,
  );

  const ListValueModel.value(String value)
      : this(
    value: value,
  );

  @override
  List<Object?> get props => [
    value,
  ];

  @override
  String get itemName => alt ?? value;

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      'value': value,
      'alt': alt != value ? alt : null,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static ListValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ListValueModel(
      value: json['value'],
      alt: json['alt'],
    );
  }
}