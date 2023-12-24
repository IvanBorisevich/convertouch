import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/output/units_states.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class UnitsBlocForUnitCreation extends ConvertouchBloc<UnitsEvent, UnitsState> {
  final FetchUnitsUseCase fetchUnitsUseCase;

  UnitsBlocForUnitCreation({
    required this.fetchUnitsUseCase,
  }) : super(
          const UnitsFetchedForUnitCreation(
            units: [],
            unitGroup: null,
            currentSelectedBaseUnit: null,
            searchString: null,
          ),
        );

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnitsForUnitCreation) {
      final result = await fetchUnitsUseCase.execute(event);

      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
        );
      } else {
        yield UnitsFetchedForUnitCreation(
          units: result.right,
          unitGroup: event.unitGroup,
          currentSelectedBaseUnit: event.currentSelectedBaseUnit,
          searchString: event.searchString,
        );
      }
    }
  }
}
