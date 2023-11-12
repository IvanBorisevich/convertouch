import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups({
    this.selectedUnitGroupId = -1,
    this.markedUnits = const [],
    required this.action,
  });

  final int selectedUnitGroupId;
  final List<UnitModel> markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [
    selectedUnitGroupId,
    markedUnits,
    action,
  ];

  @override
  String toString() {
    return 'FetchUnitGroups{'
        'selectedUnitGroupId: $selectedUnitGroupId, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}

class AddUnitGroup extends UnitGroupsEvent {
  const AddUnitGroup({
    required this.unitGroupName,
  });

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'AddUnitGroup{unitGroupName: $unitGroupName}';
  }
}

class SelectUnitGroup extends UnitGroupsEvent {
  const SelectUnitGroup({
    required this.unitGroup
  });

  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'SelectUnitGroup{unitGroup: $unitGroup}';
  }
}

class RemoveUnitGroups extends UnitGroupsEvent {
  final List<int> ids;

  const RemoveUnitGroups({
    required this.ids,
  });

  @override
  List<Object> get props => [ids];

  @override
  String toString() {
    return 'RemoveUnitGroups{ids: $ids}';
  }
}