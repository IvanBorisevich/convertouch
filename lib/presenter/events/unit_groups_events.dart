import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups({
    this.selectedUnitGroupId,
    this.initial = false,
    this.forPage,
  });

  final int? selectedUnitGroupId;
  final bool initial;
  final String? forPage;

  @override
  String toString() {
    return 'FetchUnitGroups{'
        'selectedUnitGroupId: $selectedUnitGroupId, '
        'initial: $initial, '
        'forPage: $forPage}';
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