import 'package:convertouch/domain/model/item_model.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsSearchState extends Equatable {
  final List<IdNameItemModel> foundItems;

  const ItemsSearchState({
    this.foundItems = const [],
  });

  @override
  List<Object> get props => [
    foundItems,
  ];
}

class ItemsSearchInitState extends ItemsSearchState {
  const ItemsSearchInitState();

  @override
  String toString() {
    return 'ItemsSearchInitState{}';
  }
}

class UnitGroupsFound extends ItemsSearchState {
  const UnitGroupsFound({
    super.foundItems,
  });

  @override
  String toString() {
    return 'UnitGroupsFound{'
        'foundItems: ${super.foundItems}}';
  }
}

class UnitsFound extends ItemsSearchState {
  const UnitsFound({
    super.foundItems,
  });

  @override
  String toString() {
    return 'UnitsFound{'
        'foundItems: ${super.foundItems}}';
  }
}

class ItemsSearchErrorState extends ItemsSearchState {
  final String message;

  const ItemsSearchErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ItemsSearchErrorState{message: $message}';
  }
}