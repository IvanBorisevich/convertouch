import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
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
  final int? conversionGroupId;

  const SaveUnitGroup({
    required this.unitGroupToBeSaved,
    this.conversionGroupId,
  });

  @override
  List<Object?> get props => [
        unitGroupToBeSaved,
        conversionGroupId,
      ];

  @override
  String toString() {
    return 'SaveUnitGroup{'
        'unitGroupToBeSaved: $unitGroupToBeSaved, '
        'conversionGroupId: $conversionGroupId}';
  }
}
