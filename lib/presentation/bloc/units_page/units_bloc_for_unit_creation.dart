import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBlocForUnitCreation extends Bloc<UnitsEvent, UnitsState> {
  final FetchUnitsOfGroupUseCase fetchUnitsOfGroupUseCase;

  UnitsBlocForUnitCreation({
    required this.fetchUnitsOfGroupUseCase,
  }) : super(
          const UnitsFetchedForUnitCreation(
            units: [],
            unitGroup: null,
            currentSelectedBaseUnit: null,
          ),
        );

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnitsForUnitCreation) {
      var unitGroup = event.unitGroup;

      final result = await fetchUnitsOfGroupUseCase.execute(unitGroup.id!);

      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
        );
      } else {
        yield UnitsFetchedForUnitCreation(
          units: result.right,
          unitGroup: unitGroup,
          currentSelectedBaseUnit: event.currentSelectedBaseUnit,
        );
      }
    }
  }
}
