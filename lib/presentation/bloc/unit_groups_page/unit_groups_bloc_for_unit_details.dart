import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBlocForUnitDetails
    extends ConvertouchBloc<ConvertouchEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final NavigationBloc navigationBloc;

  UnitGroupsBlocForUnitDetails({
    required this.fetchUnitGroupsUseCase,
    required this.navigationBloc,
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
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      emit(
        UnitGroupsFetchedForUnitDetails(
          unitGroups: result.right,
          unitGroupInUnitDetails: event.currentUnitGroupInUnitDetails,
          searchString: event.searchString,
        ),
      );
      navigationBloc.add(
        const NavigateToPage(
          pageName: PageName.unitGroupsPageForUnitDetails,
        ),
      );
    }
  }
}
