import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBlocForConversion extends Bloc<UnitsEvent, UnitsState> {
  static const int _minUnitsNumForConversion = 2;

  final FetchUnitsOfGroupUseCase fetchUnitsOfGroupUseCase;

  UnitsBlocForConversion({
    required this.fetchUnitsOfGroupUseCase,
})
      : super(const UnitsFetchedToMarkForConversion(
          units: [],
          unitGroup: null,
          unitsMarkedForConversion: [],
          unitIdsMarkedForConversion: [],
          allowUnitsToBeAddedToConversion: false,
        ));

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnits) {
      final result = await fetchUnitsOfGroupUseCase.execute(
        event.unitGroup.id!,
      );

      if (result.isLeft) {
        yield UnitsErrorState(message: result.left.message);
      } else {
        if (event is FetchUnitsToMarkForConversion) {
          List<UnitModel> allMarkedUnits = _updateMarkedUnits(
            event.unitsAlreadyMarkedForConversion,
            event.unitNewlyMarkedForConversion,
          );

          List<int> allMarkedUnitIds =
          allMarkedUnits.map((unit) => unit.id!).toList();

          yield UnitsFetchedToMarkForConversion(
            units: result.right,
            unitGroup: event.unitGroup,
            unitIdsMarkedForConversion: allMarkedUnitIds,
            unitsMarkedForConversion: allMarkedUnits,
            allowUnitsToBeAddedToConversion:
            allMarkedUnitIds.length >= _minUnitsNumForConversion,
            currentSourceConversionItem: event.currentSourceConversionItem,
          );
        }
      }
    }
  }

  List<UnitModel> _updateMarkedUnits(
    List<UnitModel>? unitsAlreadyMarkedForConversion,
    UnitModel? unitNewlyMarkedForConversion,
  ) {
    List<UnitModel> result = [];

    if (unitsAlreadyMarkedForConversion != null &&
        unitsAlreadyMarkedForConversion.isNotEmpty) {
      result = unitsAlreadyMarkedForConversion;
    }

    if (unitNewlyMarkedForConversion != null) {
      if (!result.contains(unitNewlyMarkedForConversion)) {
        result.add(unitNewlyMarkedForConversion);
      } else {
        result.removeWhere((unit) => unit == unitNewlyMarkedForConversion);
      }
    }

    return result;
  }
}
