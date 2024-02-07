import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBlocForUnitDetails
    extends ConvertouchBloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;

  UnitGroupsBlocForUnitDetails({
    required this.fetchUnitGroupsUseCase,
  }) : super(
          const UnitGroupsFetchedForUnitDetails(
            unitGroups: [],
            searchString: null,
          ),
        ) {
    on<FetchUnitGroupsForUnitDetails>(_onUnitGroupsFetchForUnitDetails);
  }

  _onUnitGroupsFetchForUnitDetails(
    FetchUnitGroupsForUnitDetails event,
    Emitter<UnitGroupsState> emit,
  ) async {
    final result = await fetchUnitGroupsUseCase.execute(event.searchString);

    if (result.isLeft) {
      emit(
        UnitGroupsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      emit(
        UnitGroupsFetchedForUnitDetails(
          unitGroups: result.right,
          unitGroupInUnitDetails: event.currentUnitGroupInUnitDetails,
          searchString: event.searchString,
        ),
      );
    }
  }
}
