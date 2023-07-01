import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsMenuBloc
    extends Bloc<UnitGroupsMenuEvent, UnitGroupsMenuState> {
  UnitGroupsMenuBloc() : super(const UnitGroupsFetched(unitGroups: []));

  @override
  Stream<UnitGroupsMenuState> mapEventToState(UnitGroupsMenuEvent event) async* {
    if (event is FetchUnitGroups) {
      yield UnitGroupsFetched(unitGroups: allUnitGroups);
    }
  }
}

const List<UnitGroupModel> allUnitGroups = [
  UnitGroupModel(1, 'Length'),
  UnitGroupModel(2, 'Area'),
  UnitGroupModel(3, 'Volume'),
  UnitGroupModel(4, 'Speed'),
  UnitGroupModel(5, 'Mass'),
  UnitGroupModel(6, 'Currency'),
  UnitGroupModel(7, 'Temperature'),
  UnitGroupModel(8, 'Numeral System'),
  UnitGroupModel(9, 'Length1 ehuefuhe uehfuehufhe fheufh'),
  UnitGroupModel(10, 'Length1dsdsdsdsddsddsdsdsssd'),
  UnitGroupModel(11, 'Len dd dd'),
  UnitGroupModel(12, 'Length11'),
  UnitGroupModel(13, 'Length'),
  UnitGroupModel(14, 'Length'),
  UnitGroupModel(15, 'Length'),
  UnitGroupModel(16, 'Length'),
  UnitGroupModel(17, 'Length'),
  UnitGroupModel(18, 'Length'),
  UnitGroupModel(19, 'Length'),
  UnitGroupModel(20, 'Length'),
  UnitGroupModel(21, 'Length'),
];
