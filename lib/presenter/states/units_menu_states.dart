import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitsMenuState extends BlocState {
  const UnitsMenuState();
}

class UnitsFetching extends UnitsMenuState {
  const UnitsFetching();

  @override
  String toString() {
    return 'UnitsFetching{}';
  }
}

class UnitsFetched extends UnitsMenuState {
  const UnitsFetched({
    required this.units
  });

  final List<UnitModel> units;

  @override
  List<Object> get props => [units];

  @override
  String toString() {
    return 'UnitsFetched{units: $units}';
  }
}


class UnitsSelected extends UnitsMenuState {
  const UnitsSelected({
    required this.selectedUnits
  });

  final List<UnitModel> selectedUnits;

  @override
  List<Object> get props => [selectedUnits];

  @override
  String toString() {
    return 'UnitsSelected{selectedUnits: $selectedUnits}';
  }
}