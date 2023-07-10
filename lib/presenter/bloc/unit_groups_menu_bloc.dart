import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsMenuBloc
    extends Bloc<UnitGroupsMenuEvent, UnitGroupsMenuState> {
  UnitGroupsMenuBloc() : super(const UnitGroupsFetched(unitGroups: []));

  @override
  Stream<UnitGroupsMenuState> mapEventToState(
      UnitGroupsMenuEvent event) async* {
    if (event is FetchUnitGroups) {
      yield const UnitGroupsFetching();
      yield UnitGroupsFetched(
          unitGroups: allUnitGroups,
          navigationAction: event.navigationAction
      );
    } else if (event is AddUnitGroup) {
      yield const UnitGroupAdding();

      bool unitGroupExists = allUnitGroups
          .any((unitGroup) => event.unitGroupName == unitGroup.name);

      if (!unitGroupExists) {
        UnitGroupModel newUnitGroup =
            UnitGroupModel(allUnitGroups.length + 1, event.unitGroupName);
        allUnitGroups.add(newUnitGroup);
        yield UnitGroupAdded(unitGroup: newUnitGroup);
      } else {
        yield UnitGroupExists(unitGroupName: event.unitGroupName);
      }
    }
  }
}

final List<UnitGroupModel> allUnitGroups = [
  UnitGroupModel(1, 'Length', ciUnitId: 1),
  UnitGroupModel(2, 'Area'),
  UnitGroupModel(3, 'Volume'),
  // UnitGroupModel(4, 'Speed'),
  // UnitGroupModel(5, 'Mass'),
  // UnitGroupModel(6, 'Currency'),
  // UnitGroupModel(7, 'Temperature'),
  // UnitGroupModel(8, 'Numeral System'),
];
