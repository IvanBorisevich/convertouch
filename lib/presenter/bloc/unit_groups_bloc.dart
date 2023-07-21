import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/unit_groups_events.dart';
import 'package:convertouch/presenter/states/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc
    extends Bloc<UnitGroupsEvent, UnitGroupsState> {
  UnitGroupsBloc() : super(const UnitGroupsFetched(unitGroups: []));

  @override
  Stream<UnitGroupsState> mapEventToState(
      UnitGroupsEvent event) async* {
    if (event is FetchUnitGroups) {
      yield const UnitGroupsFetching();
      yield UnitGroupsFetched(
        unitGroups: allUnitGroups,
        selectedUnitGroupId: event.selectedUnitGroupId,
        forPage: event.forPage,
      );
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
        );
      } else {
        yield UnitGroupExists(unitGroupName: event.unitGroupName);
      }
    } else if (event is SelectUnitGroup) {
      yield const UnitGroupSelecting();
      yield UnitGroupSelected(
        unitGroup: event.unitGroup
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
