import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class UnitGroupsState extends ConvertouchPageState {
  const UnitGroupsState({
    super.pageId = unitGroupsPageId,
    super.prevState,
    super.pageTitle = "Unit Groups",
    super.startPageIndex = 1,
    super.unitGroupInConversion,
    super.floatingButtonVisible = true,
    super.removalMode,
    super.selectedItemIdsForRemoval,
    super.pageViewMode = ItemsViewMode.grid,
    super.iconViewMode = ItemsViewMode.list,
    super.theme,
  });
}

class UnitGroupsInitState extends UnitGroupsState {
  const UnitGroupsInitState();

  @override
  String toString() {
    return 'UnitGroupsInitState{${super.toString()}}';
  }
}

class UnitGroupsFetching extends UnitGroupsState {
  const UnitGroupsFetching();

  @override
  String toString() {
    return 'UnitGroupsFetching{}';
  }
}

class UnitGroupsFetched extends UnitGroupsState {
  final List<UnitGroupModel> unitGroups;

  const UnitGroupsFetched({
    required this.unitGroups,
    super.prevState,
    super.startPageIndex,
    super.pageTitle,
    super.unitGroupInConversion,
  });

  @override
  List<Object?> get props => [
    unitGroups,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitGroups: $unitGroups'
        '${super.toString()}'
        '}';
  }
}

class UnitGroupsFetchedForConversion extends UnitGroupsFetched {
  const UnitGroupsFetchedForConversion({
    required super.unitGroups,
    super.unitGroupInConversion,
  });

  @override
  String toString() {
    return 'UnitGroupsFetchedForConversion{${super.toString()}}';
  }
}

class UnitGroupsFetchedForUnitCreation extends UnitGroupsFetched {
  final UnitGroupModel? unitGroupInUnitCreation;

  const UnitGroupsFetchedForUnitCreation({
    required super.unitGroups,
    this.unitGroupInUnitCreation,
  });

  @override
  List<Object?> get props => [
    unitGroupInUnitCreation,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetchedForUnitCreation{'
        'unitGroupInUnitCreation: $unitGroupInUnitCreation'
        '${super.toString()}}';
  }
}


class UnitGroupsErrorState extends UnitGroupsState {
  final String message;

  const UnitGroupsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitGroupsErrorState{message: $message}';
  }
}