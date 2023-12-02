import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBlocForConversion extends Bloc<UnitsEvent, UnitsState> {
  static const int _minUnitsNumForConversion = 2;

  UnitsBlocForConversion()
      : super(const UnitsFetchedForConversion(
          unitsMarkedForConversion: [],
          unitIdsMarkedForConversion: [],
          allowUnitsToBeAddedToConversion: false,
        ));

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    if (event is FetchUnitsForConversion) {
      List<UnitModel> allMarkedUnits = _updateMarkedUnits(
        event.unitsAlreadyMarkedForConversion,
        event.unitNewlyMarkedForConversion,
      );

      List<int> allMarkedUnitIds =
          allMarkedUnits.map((unit) => unit.id!).toList();

      yield UnitsFetchedForConversion(
        unitIdsMarkedForConversion: allMarkedUnitIds,
        unitsMarkedForConversion: allMarkedUnits,
        allowUnitsToBeAddedToConversion:
            allMarkedUnitIds.length >= _minUnitsNumForConversion,
      );
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
