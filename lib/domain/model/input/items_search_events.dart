import 'package:convertouch/domain/model/unit_group_model.dart';
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
  final UnitGroupModel unitGroup;

  const SearchUnits({
    required super.searchString,
    required this.unitGroup,
  });

  @override
  List<Object> get props => [
    searchString,
    unitGroup,
  ];

  @override
  String toString() {
    return 'SearchUnits{'
        'unitGroup: $unitGroup, '
        'searchString: ${super.searchString}}';
  }
}