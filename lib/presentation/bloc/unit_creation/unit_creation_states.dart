import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

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

  final UnitGroupEntity unitGroup;
  final UnitEntity? equivalentUnit;
  final List<UnitEntity>? markedUnits;
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