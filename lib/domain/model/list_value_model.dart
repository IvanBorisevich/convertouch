import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ListValueModel extends IdNameSearchableItemModel {
  static const ListValueModel none = ListValueModel(value: '');

  final String value;
  final String? alt;
  final NumRange? range;

  const ListValueModel({
    required this.value,
    this.alt,
    this.range,
  }) : super(
          id: -1,
          name: '',
          itemType: ItemType.listValue,
          oob: true,
        );

  const ListValueModel.raw(String value)
      : this(
          value: value,
          alt: value,
        );

  factory ListValueModel.value(ValueModel value) {
    return ListValueModel(
      value: value.raw,
      alt: value.altOrRaw,
      range: value.range,
    );
  }

  factory ListValueModel.range(NumRange range) {
    return ListValueModel(
      value: range.rangeName,
      alt: range.rangeName,
      range: range,
    );
  }

  @override
  List<Object?> get props => [
        value,
        alt,
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
      alt: json['alt'] ?? json['value'],
    );
  }

  @override
  String toString() {
    return 'ListValue{value: $value, alt: $alt}';
  }
}
