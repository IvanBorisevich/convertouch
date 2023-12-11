import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/output/unit_groups_states.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBlocForConversion
    extends Bloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;

  UnitGroupsBlocForConversion({
    required this.fetchUnitGroupsUseCase,
  }) : super(const UnitGroupsFetchedForFirstAddingToConversion(unitGroups: []));

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    yield const UnitGroupsFetching();

    if (event is FetchUnitGroups) {
      final result = await fetchUnitGroupsUseCase.execute();

      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
        );
      } else {
        if (event is FetchUnitGroupsForFirstAddingToConversion) {
          yield UnitGroupsFetchedForFirstAddingToConversion(
            unitGroups: result.right,
          );
        } else if (event is FetchUnitGroupsForChangeInConversion) {
          yield UnitGroupsFetchedForChangeInConversion(
            unitGroups: result.right,
            currentUnitGroupInConversion: event.currentUnitGroupInConversion,
          );
        }
      }
    }
  }
}
