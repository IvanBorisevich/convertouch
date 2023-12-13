import 'package:equatable/equatable.dart';

abstract class ItemsSearchEvent extends Equatable {
  const ItemsSearchEvent();

  @override
  List<Object> get props => [];
}

class ResetSearch extends ItemsSearchEvent {
  const ResetSearch();

  @override
  String toString() {
    return 'ResetSearch{}';
  }
}

abstract class SearchItems extends ItemsSearchEvent {
  final String searchString;

  const SearchItems({
    required this.searchString,
  });

  @override
  List<Object> get props => [
        searchString,
      ];
}

class SearchUnitGroups extends SearchItems {
  const SearchUnitGroups({
    required super.searchString,
  });

  @override
  String toString() {
    return 'SearchUnitGroups{'
        'searchString: ${super.searchString}}';
  }
}

class SearchUnits extends SearchItems {
  final int unitGroupId;

  const SearchUnits({
    required super.searchString,
    required this.unitGroupId,
  });

  @override
  List<Object> get props => [
        searchString,
        unitGroupId,
      ];

  @override
  String toString() {
    return 'SearchUnits{'
        'unitGroupId: $unitGroupId, '
        'searchString: ${super.searchString}}';
  }
}
