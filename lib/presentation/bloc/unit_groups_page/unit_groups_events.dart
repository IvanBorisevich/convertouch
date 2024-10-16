import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent({
    super.onComplete,
  });
}

class FetchUnitGroups extends UnitGroupsEvent {
  final String? searchString;

  const FetchUnitGroups({
    this.searchString,
  });

  @override
  List<Object?> get props => [
        searchString,
      ];

  @override
  String toString() {
    return 'FetchUnitGroups{'
        'searchString: $searchString}';
  }
}

class RemoveUnitGroups extends UnitGroupsEvent {
  final List<int> ids;

  const RemoveUnitGroups({
    required this.ids,
    super.onComplete,
  });

  @override
  List<Object?> get props => [
        ids,
        super.props,
      ];

  @override
  String toString() {
    return 'RemoveUnitGroups{'
        'ids: $ids}';
  }
}

class SaveUnitGroup extends UnitGroupsEvent {
  final UnitGroupModel unitGroupToBeSaved;
  final void Function(UnitGroupModel)? onSaveGroup;

  const SaveUnitGroup({
    required this.unitGroupToBeSaved,
    this.onSaveGroup,
  });

  @override
  List<Object?> get props => [
        unitGroupToBeSaved,
      ];

  @override
  String toString() {
    return 'SaveUnitGroup{unitGroupToBeSaved: $unitGroupToBeSaved}';
  }
}
