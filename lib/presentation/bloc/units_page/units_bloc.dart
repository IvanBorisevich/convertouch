import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends ConvertouchBloc<ConvertouchEvent, UnitsState> {
  final FetchUnitsUseCase fetchUnitsUseCase;
  final SaveUnitUseCase saveUnitUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;
  final NavigationBloc navigationBloc;

  UnitsBloc({
    required this.saveUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
    required this.navigationBloc,
  }) : super(const UnitsInitialState()) {
    on<FetchUnits>(_onUnitsFetch);
    on<SaveUnit>(_onUnitSave);
    on<RemoveUnits>(_onUnitsRemove);
    on<EditOpenedGroup>(_onEditOpenedGroup);
    on<ModifyUnit>(_onModifyUnit);
  }

  _onUnitsFetch(
    FetchUnits event,
    Emitter<UnitsState> emit,
  ) async {
    final result = await fetchUnitsUseCase.execute(
      InputUnitFetchModel(
        searchString: event.searchString,
        unitGroupId: event.unitGroup.id,
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
        UnitsFetched(
          units: result.right,
          unitGroup: event.unitGroup,
        ),
      );

      event.onComplete?.call();
    }
  }

  _onUnitSave(
    SaveUnit event,
    Emitter<UnitsState> emit,
  ) async {
    final result = await saveUnitUseCase.execute(event.unit);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      add(
        FetchUnits(
          unitGroup: event.unitGroup,
          searchString: null,
        ),
      );
    }
  }

  _onUnitsRemove(
    RemoveUnits event,
    Emitter<UnitsState> emit,
  ) async {
    UnitsFetched currentState = state as UnitsFetched;

    final result = await removeUnitsUseCase.execute(event.ids);
    if (result.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: result.left,
        ),
      );
    } else {
      add(
        FetchUnits(
          unitGroup: event.unitGroup,
          searchString: currentState.searchString,
        ),
      );
    }
  }

  _onEditOpenedGroup(
    EditOpenedGroup event,
    Emitter<UnitsState> emit,
  ) async {
    if (state is UnitsFetched) {
      UnitsFetched current = state as UnitsFetched;

      if (event.editedGroup.id == current.unitGroup.id) {
        emit(
          UnitsFetched(
            units: current.units,
            unitGroup: event.editedGroup,
            searchString: current.searchString,
          ),
        );
      }
    }

    event.onComplete?.call();
  }

  _onModifyUnit(
    ModifyUnit event,
    Emitter<UnitsState> emit,
  ) async {
    UnitsFetched currentState = state as UnitsFetched;

    await _onUnitsFetch(
      FetchUnits(
        unitGroup: currentState.unitGroup,
        searchString: currentState.searchString,
      ),
      emit,
    );
  }
}

class UnitsBlocForConversion extends UnitsBloc {
  UnitsBlocForConversion({
    required super.fetchUnitsUseCase,
    required super.saveUnitUseCase,
    required super.removeUnitsUseCase,
    required super.navigationBloc,
  });
}

class UnitsBlocForUnitDetails extends UnitsBloc {
  UnitsBlocForUnitDetails({
    required super.fetchUnitsUseCase,
    required super.saveUnitUseCase,
    required super.removeUnitsUseCase,
    required super.navigationBloc,
  });
}
