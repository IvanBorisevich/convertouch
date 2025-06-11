import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ItemModel extends Equatable {
  final ItemType itemType;
  final bool oob;

  const ItemModel({
    required this.itemType,
    this.oob = false,
  });

  Map<String, dynamic> toJson({bool removeNulls = true});
}

abstract class IdNameItemModel extends ItemModel {
  final int id;
  final String name;

  const IdNameItemModel({
    this.id = -1,
    required this.name,
    required super.itemType,
    super.oob,
  });

  bool get hasId => id != -1;
}

class ItemSearchMatch {
  static const none = ItemSearchMatch();

  final List<String> lexemes;
  final int matchedLexemeIndex;

  const ItemSearchMatch({
    this.lexemes = const [],
    this.matchedLexemeIndex = -1,
  });

  @override
  String toString() {
    return 'ItemSearchMatch{'
        'lexemes: $lexemes, '
        'matchedLexemeIndex: $matchedLexemeIndex}';
  }
}

abstract class IdNameSearchableItemModel extends IdNameItemModel {
  final ItemSearchMatch nameMatch;

  const IdNameSearchableItemModel({
    this.nameMatch = ItemSearchMatch.none,
    super.id,
    required super.name,
    required super.itemType,
    super.oob,
  });

  String get itemName {
    return name;
  }
}

class ListValueModel extends IdNameSearchableItemModel {
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
