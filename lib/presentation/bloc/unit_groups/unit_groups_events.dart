import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups({
    this.selectedUnitGroupId,
    this.markedUnits,
    required this.action,
  });

  final int? selectedUnitGroupId;
  final List<UnitEntity>? markedUnits;
  final ConvertouchAction action;

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

  final UnitGroupEntity unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'SelectUnitGroup{unitGroup: $unitGroup}';
  }
}