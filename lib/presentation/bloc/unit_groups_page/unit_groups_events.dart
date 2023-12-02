import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitGroupsEvent extends Equatable {
  const UnitGroupsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups();

  @override
  String toString() {
    return 'FetchUnitGroups{}';
  }
}

class FetchUnitGroupsToFetchUnitsForConversion extends FetchUnitGroups {
  const FetchUnitGroupsToFetchUnitsForConversion();

  @override
  String toString() {
    return 'FetchUnitGroupsToFetchUnitsForConversion{}';
  }
}

class FetchUnitGroupsToChangeOneInConversion extends FetchUnitGroups {
  final UnitGroupModel unitGroupInConversion;

  const FetchUnitGroupsToChangeOneInConversion({
    required this.unitGroupInConversion,
  });

  @override
  String toString() {
    return 'FetchUnitGroupsToChangeOneInConversion{'
        'unitGroupInConversion: $unitGroupInConversion}';
  }
}

class FetchUnitGroupsForUnitCreation extends FetchUnitGroups {
  const FetchUnitGroupsForUnitCreation();

  @override
  String toString() {
    return 'FetchUnitGroupsForUnitCreation{}';
  }
}


class PrepareUnitGroupCreation extends UnitGroupsEvent {
  const PrepareUnitGroupCreation();

  @override
  String toString() {
    return 'PrepareUnitGroupCreation{}';
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
        'ids: $ids}';
  }
}
