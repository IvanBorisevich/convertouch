import 'package:convertouch/domain/model/usecases/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';

class UnitsBlocForUnitCreation extends ConvertouchBloc<UnitsEvent, UnitsState> {
  final FetchUnitsUseCase fetchUnitsUseCase;

  UnitsBlocForUnitCreation({
    required this.fetchUnitsUseCase,
  }) : super(const UnitsInitialState());

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnitsForUnitCreation) {
      final result = await fetchUnitsUseCase.execute(
        InputUnitFetchModel(
          searchString: event.searchString,
          unitGroupId: event.unitGroup.id!,
        ),
      );

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
