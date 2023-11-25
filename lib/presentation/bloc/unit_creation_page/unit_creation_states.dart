import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';

abstract class UnitCreationState extends ConvertouchPageState {
  const UnitCreationState({
    super.pageId = unitCreationPageId,
    super.prevState = UnitsFetched,
    super.pageTitle = "New Unit",
    super.startPageIndex = 1,
    super.unitGroupInConversion,
    super.floatingButtonVisible = false,
    super.theme,
  });
}

class UnitCreationInitState extends UnitCreationState {
  const UnitCreationInitState();

  @override
  String toString() {
    return 'UnitCreationInitState{${super.toString()}}';
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
  final UnitGroupModel unitGroupOnStart;
  final UnitGroupModel unitGroupInUnitCreation;
  final UnitModel? equivalentUnit;

  const UnitCreationPrepared({
    required this.unitGroupOnStart,
    required this.unitGroupInUnitCreation,
    this.equivalentUnit,
  });

  @override
  List<Object?> get props => [
    unitGroupOnStart,
    unitGroupInUnitCreation,
    equivalentUnit,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitCreationPrepared{'
        'unitGroupOnStart: $unitGroupOnStart, '
        'unitGroupInUnitCreation: $unitGroupInUnitCreation, '
        'equivalentUnit: $equivalentUnit'
        '${super.toString()}}';
  }
}

class UnitExistenceChecking extends UnitCreationState {
  const UnitExistenceChecking();

  @override
  String toString() {
    return 'UnitExistenceChecking{}';
  }
}

class UnitExists extends UnitCreationState {
  final String unitName;

  const UnitExists({
    required this.unitName,
  });

  @override
  List<Object?> get props => [
    unitName,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitExists{'
        'unitName: $unitName'
        '${super.toString()}}';
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