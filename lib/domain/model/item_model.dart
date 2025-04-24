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

  String get itemName => name;
}

class ListValueModel extends IdNameSearchableItemModel {
  const ListValueModel(String name)
      : super(
          id: -1,
          name: name,
          itemType: ItemType.listValue,
          oob: true,
        );

  @override
  List<Object?> get props => [
        name,
      ];

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    return {
      'name': name,
    };
  }
}
