import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class UnitGroupDetailsEvent extends ConvertouchEvent {
  const UnitGroupDetailsEvent();
}

class GetNewUnitGroupDetails extends UnitGroupDetailsEvent {
  const GetNewUnitGroupDetails();

  @override
  String toString() {
    return 'GetNewUnitGroupDetails{}';
  }
}

class GetExistingUnitGroupDetails extends UnitGroupDetailsEvent {
  final UnitGroupModel unitGroup;

  const GetExistingUnitGroupDetails({
    required this.unitGroup,
  });

  @override
  String toString() {
    return 'GetExistingUnitGroupDetails{unitGroup: $unitGroup}';
  }
}

class UpdateUnitGroupName extends UnitGroupDetailsEvent {
  final String newValue;

  const UpdateUnitGroupName({
    required this.newValue,
  });

  @override
  List<Object?> get props => [
    newValue,
  ];

  @override
  String toString() {
    return 'UpdateUnitGroupName{newValue: $newValue}';
  }
}