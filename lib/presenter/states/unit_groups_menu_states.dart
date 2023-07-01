import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsMenuState extends BlocState {
  const UnitGroupsMenuState();
}

class UnitGroupsFetched extends UnitGroupsMenuState {
  const UnitGroupsFetched({
    required this.unitGroups
  });

  final List<UnitGroupModel> unitGroups;

  @override
  List<Object> get props => [unitGroups];

  @override
  String toString() {
    return 'UnitGroupsFetched{unitsGroups: $unitGroups}';
  }
}
