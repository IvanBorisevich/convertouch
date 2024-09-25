import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBlocForUnitDetails
    extends ConvertouchBloc<ConvertouchEvent, UnitsState> {
  final FetchUnitsUseCase fetchUnitsUseCase;
  final NavigationBloc navigationBloc;

  UnitsBlocForUnitDetails({
    required this.fetchUnitsUseCase,
    required this.navigationBloc,
  }) : super(const UnitsInitialState()) {
    on<FetchUnitsForUnitDetails>(_onUnitsFetchForUnitDetails);
  }

  _onUnitsFetchForUnitDetails(
    FetchUnitsForUnitDetails event,
    Emitter<UnitsState> emit,
  ) async {
    final result = await fetchUnitsUseCase.execute(
      InputUnitFetchModel(
        searchString: event.searchString,
        unitGroupId: event.unitGroup.id!,
      ),
    );

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: result.left,
        ),
      );
    } else {
      emit(
        UnitsFetchedForUnitDetails(
          units: result.right,
          unitGroup: event.unitGroup,
          selectedArgUnit: event.selectedArgUnit,
          currentEditedUnitId: event.unitIdBeingEdited,
          searchString: event.searchString,
        ),
      );
      navigationBloc.add(
        const NavigateToPage(
          pageName: PageName.unitsPageForUnitDetails,
        ),
      );
    }
  }
}
