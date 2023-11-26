import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitCreationEvent extends ConvertouchCommonEvent {
  const UnitCreationEvent({
    super.currentPageId = unitCreationPageId,
    super.startPageIndex = 1,
  });
}

class FetchUnitGroupsForUnitCreation extends UnitCreationEvent {
  const FetchUnitGroupsForUnitCreation();

  @override
  String toString() {
    return 'FetchUnitGroupsForUnitCreation{${super.toString()}}';
  }
}

class FetchUnitsForEquivalentUnitSelection extends UnitCreationEvent {
  final int unitGroupId;

  const FetchUnitsForEquivalentUnitSelection({
    required this.unitGroupId,
  });

  @override
  List<Object?> get props => [
    unitGroupId,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitsForEquivalentUnitSelection{'
        'unitGroupId: $unitGroupId, '
        '${super.toString()}}';
  }
}

class AddUnit extends UnitCreationEvent {
  final UnitModel unit;

  const AddUnit({
    required this.unit,
  });

  @override
  List<Object?> get props => [
    unit,
    super.props,
  ];

  @override
  String toString() {
    return 'AddUnit{'
        'unit: $unit, '
        '${super.toString()}}';
  }
}
