import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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
    this.markedUnits = const [],
    this.action = ConvertouchAction.initUnitCreationParams,
  });

  final UnitGroupModel unitGroup;
  final UnitModel? equivalentUnit;
  final List<UnitModel> markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroup, action, markedUnits];

  @override
  String toString() {
    return 'UnitCreationPrepared{'
        'unitGroup: $unitGroup, '
        'equivalentUnit: $equivalentUnit, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}

class UnitCreationErrorState extends UnitCreationState {
  final String message;

  const UnitCreationErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitCreationErrorState{message: $message}';
  }
}