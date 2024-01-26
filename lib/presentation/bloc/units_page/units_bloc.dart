import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends ConvertouchBloc<UnitsEvent, UnitsState> {
  final AddUnitUseCase addUnitUseCase;
  final FetchUnitsUseCase fetchUnitsUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;

  UnitsBloc({
    required this.addUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
  }) : super(const UnitsInitialState()) {
    on<FetchUnits>(_onUnitsFetch);
    on<AddUnit>(_onUnitAdd);
    on<RemoveUnits>(_onUnitsRemove);
    on<DisableUnitsRemovalMode>(_onUnitsRemovalModeDisable);
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
            addedId: event.addedId,
          ),
        );
      }
    }
  }

  _onUnitAdd(
    AddUnit event,
    Emitter<UnitsState> emit,
  ) async {
    emit(const UnitsFetching());
    final addUnitResult = await addUnitUseCase.execute(
      event.unitCreationParams,
    );

    if (addUnitResult.isLeft) {
      emit(
        UnitsErrorState(
          exception: addUnitResult.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      int addedUnitId = addUnitResult.right;

      if (addedUnitId != -1) {
        add(
          FetchUnits(
            unitGroup: event.unitCreationParams.unitGroup,
            searchString: null,
            addedId: addedUnitId,
          ),
        );
      } else {
        emit(
          UnitExists(
            unitName: event.unitCreationParams.newUnitName,
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
}
