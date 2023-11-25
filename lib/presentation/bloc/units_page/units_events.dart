import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';

abstract class UnitsEvent extends ConvertouchPageEvent {
  final UnitGroupModel unitGroup;

  const UnitsEvent({
    required this.unitGroup,
    super.currentPageId = unitsPageId,
    super.currentState = UnitsFetched,
    super.startPageIndex = 1,
  });
}

class PrepareUnitCreation extends UnitsEvent {
  final UnitModel? equivalentUnit;
  final UnitGroupModel unitGroupInUnitCreation;

  const PrepareUnitCreation({
    required this.unitGroupInUnitCreation,
    required super.unitGroup,
    this.equivalentUnit,
  });

  @override
  List<Object?> get props => [
    equivalentUnit,
    unitGroupInUnitCreation,
    super.props,
  ];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'equivalentUnit: $equivalentUnit, '
        'unitGroupInUnitCreation: $unitGroupInUnitCreation, '
        '${super.toString()}}';
  }
}

class RemoveUnits extends UnitsEvent {
  final List<int> ids;

  const RemoveUnits({
    required this.ids,
    required super.unitGroup,
  });

  @override
  List<Object> get props => [
    ids,
    super.props,
  ];

  @override
  String toString() {
    return 'RemoveUnits{'
        'ids: $ids, '
        '${super.toString()}}';
  }
}
