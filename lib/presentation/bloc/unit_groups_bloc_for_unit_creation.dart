import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/output/unit_groups_states.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class UnitGroupsBlocForUnitCreation
    extends ConvertouchBloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;

  UnitGroupsBlocForUnitCreation({
    required this.fetchUnitGroupsUseCase,
  }) : super(
          const UnitGroupsFetchedForUnitCreation(
            unitGroups: [],
            searchString: null,
          ),
        );

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    if (event is FetchUnitGroupsForUnitCreation) {
      final result = await fetchUnitGroupsUseCase.execute(event);

      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
        );
      } else {
        yield UnitGroupsFetchedForUnitCreation(
          unitGroups: result.right,
          unitGroupInUnitCreation: event.currentUnitGroupInUnitCreation,
          searchString: event.searchString,
        );
      }
    }
  }
}
