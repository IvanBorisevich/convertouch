import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBlocForConversion
    extends ConvertouchBloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;

  UnitGroupsBlocForConversion({
    required this.fetchUnitGroupsUseCase,
  }) : super(
          const UnitGroupsFetchedForFirstAddingToConversion(
            unitGroups: [],
            searchString: null,
          ),
        ) {
    on<FetchUnitGroups>(_onUnitGroupsFetch);
  }

  _onUnitGroupsFetch(
    FetchUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    emit(const UnitGroupsFetching());
    final result = await fetchUnitGroupsUseCase.execute(event.searchString);

    if (result.isLeft) {
      emit(
        UnitGroupsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      if (event is FetchUnitGroupsForFirstAddingToConversion) {
        emit(
          UnitGroupsFetchedForFirstAddingToConversion(
            unitGroups: result.right,
            searchString: event.searchString,
          ),
        );
      } else if (event is FetchUnitGroupsForChangeInConversion) {
        emit(
          UnitGroupsFetchedForChangeInConversion(
            unitGroups: result.right,
            currentUnitGroupInConversion: event.currentUnitGroupInConversion,
            searchString: event.searchString,
          ),
        );
      }
    }
  }
}
