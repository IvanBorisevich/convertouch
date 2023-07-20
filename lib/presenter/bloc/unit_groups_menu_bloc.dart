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
      yield UnitGroupsFetched(unitGroups: allUnitGroups, triggeredBy: event.triggeredBy);
    } else if (event is AddUnitGroup) {
      yield const UnitGroupsFetching();

      bool unitGroupExists = allUnitGroups
          .any((unitGroup) => event.unitGroupName == unitGroup.name);

      if (!unitGroupExists) {
        UnitGroupModel newUnitGroup = UnitGroupModel(
            id: allUnitGroups.length + 1, name: event.unitGroupName);
        allUnitGroups.add(newUnitGroup);
        yield UnitGroupsFetched(
            unitGroups: allUnitGroups,
            addedUnitGroup: newUnitGroup,
            triggeredBy: event.triggeredBy);
      } else {
        yield UnitGroupExists(unitGroupName: event.unitGroupName);
      }
    } else if (event is SelectUnitGroup) {
      yield const UnitGroupSelecting();
      yield UnitGroupSelected(
        unitGroup: event.unitGroup,
        triggeredBy: event.triggeredBy
      );
    }
  }
}

final List<UnitGroupModel> allUnitGroups = [
  UnitGroupModel(id: 1, name: 'Length'),
  UnitGroupModel(id: 2, name: 'Area'),
  UnitGroupModel(id: 3, name: 'Volume'),
  // UnitGroupModel(4, 'Speed'),
  // UnitGroupModel(5, 'Mass'),
  // UnitGroupModel(6, 'Currency'),
  // UnitGroupModel(7, 'Temperature'),
  // UnitGroupModel(8, 'Numeral System'),
];
