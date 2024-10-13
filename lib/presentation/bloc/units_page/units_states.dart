import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitsState extends ConvertouchState {
  const UnitsState();
}

class UnitsInitialState extends UnitsState {
  const UnitsInitialState();

  @override
  String toString() {
    return 'UnitsInitialState{}';
  }
}

class UnitsFetched extends UnitsState {
  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final String? searchString;

  const UnitsFetched({
    this.units = const [],
    required this.unitGroup,
    this.searchString,
  });

  @override
  List<Object?> get props => [
        units,
        unitGroup,
        searchString,
      ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup}';
  }
}
