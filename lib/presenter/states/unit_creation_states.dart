import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitCreationState extends ConvertouchBlocState {
  const UnitCreationState();
}

class UnitCreationInitState extends UnitCreationState {
  const UnitCreationInitState();

  @override
  String toString() {
    return 'UnitCreationInitState{}';
  }
}

class UnitCreationPreparing extends UnitCreationState {
  const UnitCreationPreparing();

  @override
  String toString() {
    return 'UnitCreationPreparing{}';
  }
}

class UnitCreationPrepared extends UnitCreationState {
  const UnitCreationPrepared({
    required this.unitGroup,
    this.equivalentUnit,
    this.markedUnits,
    this.action = ConvertouchAction.initUnitCreationParams,
  });

  final UnitGroupModel unitGroup;
  final UnitModel? equivalentUnit;
  final List<UnitModel>? markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroup, action];

  @override
  String toString() {
    return 'UnitCreationPrepared{'
        'unitGroup: $unitGroup, '
        'equivalentUnit: $equivalentUnit, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}