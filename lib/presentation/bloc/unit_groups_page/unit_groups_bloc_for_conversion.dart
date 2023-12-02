import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBlocForConversion
    extends Bloc<UnitGroupsEvent, UnitGroupsState> {
  UnitGroupsBlocForConversion()
      : super(const UnitGroupsFetchedToFetchUnitsForConversion());

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    if (event is FetchUnitGroupsToChangeOneInConversion) {
      yield UnitGroupsFetchedToChangeOneInConversion(
        unitGroupInConversion: event.unitGroupInConversion,
      );
    }
  }
}
