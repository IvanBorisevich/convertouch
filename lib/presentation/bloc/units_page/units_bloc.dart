import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends ConvertouchBloc<ConvertouchEvent, UnitsState> {
  final SaveUnitUseCase saveUnitUseCase;
  final FetchUnitsUseCase fetchUnitsUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;

  UnitsBloc({
    required this.saveUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
  }) : super(const UnitsInitialState()) {
    on<FetchUnits>(_onUnitsFetch);
    on<SaveUnit>(_onUnitSave);
    on<RemoveUnits>(_onUnitsRemove);
    on<DisableUnitsRemovalMode>(_onUnitsRemovalModeDisable);
    on<ModifyGroup>(_onGroupModify);
  }

  _onUnitsFetch(
    FetchUnits event,
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
      if (event is FetchUnitsToMarkForRemoval) {
        List<int> markedIds = [];

        if (event.alreadyMarkedIds.isNotEmpty) {
          markedIds = event.alreadyMarkedIds;
        }

        if (!markedIds.contains(event.newMarkedId)) {
          markedIds.add(event.newMarkedId);
        } else {
          markedIds.remove(event.newMarkedId);
        }

        List<int> oobUnitIds = result.right
            .where((unit) => unit.oob)
            .map((unit) => unit.id!)
            .toList();

        markedIds = markedIds
            .whereNot((unitId) => oobUnitIds.contains(unitId))
            .toList();

        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removalMode: true,
            markedIdsForRemoval: markedIds,
          ),
        );
      } else {
        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removedIds: event.removedIds,
            modifiedUnit: event.modifiedUnit,
            rebuildConversion: event.rebuildConversion,
          ),
        );
      }
    }
  }

  _onUnitSave(
    SaveUnit event,
    Emitter<UnitsState> emit,
  ) async {
    emit(const UnitsFetching());
    final saveUnitResult = await saveUnitUseCase.execute(event.unitToBeSaved);

    if (saveUnitResult.isLeft) {
      emit(
        UnitsErrorState(
          exception: saveUnitResult.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      UnitModel? savedUnit = saveUnitResult.right;

      if (savedUnit != null) {
        add(
          FetchUnits(
            unitGroup: event.unitGroup,
            searchString: null,
            modifiedUnit: event.unitToBeSaved,
            rebuildConversion: event.conversionGroupId == event.prevUnitGroupId,
          ),
        );
      } else {
        emit(
          UnitExists(
            unitName: event.unitToBeSaved.name,
          ),
        );
      }
    }
  }

  _onUnitsRemove(
    RemoveUnits event,
    Emitter<UnitsState> emit,
  ) async {
    emit(const UnitsFetching());
    final result = await removeUnitsUseCase.execute(event.ids);
    if (result.isLeft) {
      emit(
        UnitsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      add(
        FetchUnits(
          unitGroup: event.unitGroup,
          searchString: null,
          removedIds: event.ids,
          rebuildConversion: event.ids.isNotEmpty,
        ),
      );
    }
  }

  _onUnitsRemovalModeDisable(
    DisableUnitsRemovalMode event,
    Emitter<UnitsState> emit,
  ) async {
    add(
      FetchUnits(
        unitGroup: event.unitGroup,
        searchString: null,
      ),
    );
  }

  _onGroupModify(
    ModifyGroup event,
    Emitter<UnitsState> emit,
  ) async {
    if (state is UnitsFetched) {
      UnitsFetched currentState = state as UnitsFetched;

      if (event.modifiedGroup.id! == currentState.unitGroup.id!) {
        emit(
          UnitsFetched(
            units: currentState.units,
            unitGroup: event.modifiedGroup,
            searchString: currentState.searchString,
            removalMode: currentState.removalMode,
            markedIdsForRemoval: currentState.markedIdsForRemoval,
            removedIds: currentState.removedIds,
            modifiedUnit: currentState.modifiedUnit,
            rebuildConversion: currentState.rebuildConversion,
          ),
        );
      }
    }
  }
}
