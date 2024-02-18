import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBlocForConversion extends ConvertouchBloc<UnitsEvent, UnitsState> {
  static const int _minUnitsNumForConversion = 2;

  final FetchUnitsUseCase fetchUnitsUseCase;

  UnitsBlocForConversion({
    required this.fetchUnitsUseCase,
  }) : super(const UnitsInitialState()) {
    on<FetchUnitsToMarkForConversion>(_onFetchUnitsToMarkForConversion);
    on<FetchUnitsForChangeInConversion>(_onFetchUnitsForChangeInConversion);
  }

  _onFetchUnitsToMarkForConversion(
    FetchUnitsToMarkForConversion event,
    Emitter<UnitsState> emit,
  ) async {
    emit(const UnitsFetching());

    final result = await fetchUnitsUseCase.execute(
      InputUnitFetchModel(
        searchString: event.searchString,
        unitGroupId: event.unitGroup.id!,
      ),
    );

    if (result.isLeft) {
      emit(
        UnitsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      List<UnitModel> allMarkedUnits = _updateMarkedUnits(
        event.unitsAlreadyMarkedForConversion,
        event.unitNewlyMarkedForConversion,
      );

      emit(
        UnitsFetchedToMarkForConversion(
          units: result.right,
          unitGroup: event.unitGroup,
          unitsMarkedForConversion: allMarkedUnits,
          allowUnitsToBeAddedToConversion:
              allMarkedUnits.length >= _minUnitsNumForConversion,
          currentSourceConversionItem: event.currentSourceConversionItem,
          searchString: event.searchString,
          navigateToPage: event.navigateToPage,
        ),
      );
    }
  }

  _onFetchUnitsForChangeInConversion(
    FetchUnitsForChangeInConversion event,
    Emitter<UnitsState> emit,
  ) async {
    emit(const UnitsFetching());

    final result = await fetchUnitsUseCase.execute(
      InputUnitFetchModel(
        searchString: event.searchString,
        unitGroupId: event.unitGroup.id!,
      ),
    );

    if (result.isLeft) {
      emit(
        UnitsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      emit(
        UnitsFetchedForChangeInConversion(
          selectedUnit: event.currentSelectedUnit,
          units: result.right,
          unitsMarkedForConversion: event.unitsInConversion,
          currentSourceConversionItem: event.currentSourceConversionItem,
          unitGroup: event.unitGroup,
          searchString: event.searchString,
          navigateToPage: event.navigateToPage,
        ),
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
