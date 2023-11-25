import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitGroupsEvent extends ConvertouchPageEvent {
  const UnitGroupsEvent({
    super.currentPageId = unitGroupsPageId,
    super.currentState,
    super.startPageIndex = 1,
  });
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups();

  @override
  String toString() {
    return 'FetchUnitGroups{${super.toString()}}';
  }
}

class FetchUnitsForGroup extends UnitGroupsEvent {
  final int unitGroupId;

  const FetchUnitsForGroup({
    required this.unitGroupId,
  });

  @override
  List<Object?> get props => [
    unitGroupId,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitsForEquivalentUnitSelection{'
        'unitGroupId: $unitGroupId, '
        '${super.toString()}}';
  }
}

class PrepareUnitGroupCreation extends UnitGroupsEvent {
  const PrepareUnitGroupCreation();

  @override
  String toString() {
    return 'PrepareUnitGroupCreation{${super.toString()}}';
  }
}

class RemoveUnitGroups extends UnitGroupsEvent {
  final List<int> ids;

  const RemoveUnitGroups({
    required this.ids,
  });

  @override
  List<Object> get props => [
    ids,
    super.props,
  ];

  @override
  String toString() {
    return 'RemoveUnitGroups{'
        'ids: $ids, '
        '${super.toString()}}';
  }
}
