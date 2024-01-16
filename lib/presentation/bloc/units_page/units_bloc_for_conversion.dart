import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class UnitsBlocForConversion extends ConvertouchBloc<UnitsEvent, UnitsState> {
  static const int _minUnitsNumForConversion = 2;

  final FetchUnitsUseCase fetchUnitsUseCase;

  UnitsBlocForConversion({
    required this.fetchUnitsUseCase,
  }) : super(const UnitsInitialState());

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    if (event is FetchUnitsToMarkForConversion) {
      yield const UnitsFetching();

      final result = await fetchUnitsUseCase.execute(
        InputUnitFetchModel(
            searchString: event.searchString,
            unitGroupId: event.unitGroup.id!,
        )
      );

      if (result.isLeft) {
        yield UnitsErrorState(message: result.left.message);
      } else {
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
          searchString: event.searchString,
        );
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
