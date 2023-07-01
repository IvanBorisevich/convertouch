import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsMenuState extends BlocState {
  const UnitGroupsMenuState();
}

class UnitGroupsFetched extends UnitGroupsMenuState {
  const UnitGroupsFetched({
    required this.unitGroups,
    this.firstTime = false
  });

  final List<UnitGroupModel> unitGroups;
  final bool firstTime;

  @override
  List<Object> get props => [unitGroups, firstTime];

  @override
  String toString() {
    return 'UnitGroupsFetched{unitsGroups: $unitGroups, firstTime: $firstTime}';
  }
}
