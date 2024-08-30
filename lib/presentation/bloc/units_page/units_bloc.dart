import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_for_removal_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/mark_items_for_removal_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends ConvertouchBloc<ConvertouchEvent, UnitsState> {
  final SaveUnitUseCase saveUnitUseCase;
  final FetchUnitsUseCase fetchUnitsUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;
  final MarkItemsForRemovalUseCase markItemsForRemovalUseCase;
  final NavigationBloc navigationBloc;

  UnitsBloc({
    required this.saveUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
    required this.markItemsForRemovalUseCase,
    required this.navigationBloc,
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
    final result = await fetchUnitsUseCase.execute(
      InputUnitFetchModel(
        searchString: event.searchString,
        unitGroupId: event.unitGroup.id!,
      ),
    );

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: result.left,
        ),
      );
    } else {
      if (event is FetchUnitsToMarkForRemoval) {
        final markedIdsResult = await markItemsForRemovalUseCase.execute(
          InputItemsForRemovalModel(
            newMarkedId: event.newMarkedId,
            alreadyMarkedIds: event.alreadyMarkedIds,
            oobIds: result.right.where((e) => e.oob).map((e) => e.id!).toList(),
          ),
        );

        final markedIds = ObjectUtils.tryGet(markedIdsResult).markedIds;

        emit(const UnitsFetching());
        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removalMode: markedIds.isNotEmpty,
            markedIdsForRemoval: markedIds,
          ),
        );
      } else if (event is FetchUnitsAfterUnitSaving) {
        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            modifiedUnit: event.modifiedUnit,
            rebuildConversion: event.rebuildConversion,
          ),
        );
        navigationBloc.add(
          const NavigateBack(),
        );
      } else if (event is FetchUnitsAfterUnitsRemoval) {
        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removedIds: event.removedIds,
            rebuildConversion: event.rebuildConversion,
          ),
        );
      } else if (event is FetchUnitsOnSearchStringChange) {
        UnitsFetched currentState = state as UnitsFetched;

        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removalMode: currentState.removalMode,
            markedIdsForRemoval: currentState.markedIdsForRemoval,
          ),
        );
      } else {
        emit(
          UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
          ),
        );
        navigationBloc.add(
          const NavigateToPage(pageName: PageName.unitsPageRegular),
        );
      }
    }
  }

  _onUnitSave(
    SaveUnit event,
    Emitter<UnitsState> emit,
  ) async {
    final saveUnitResult = await saveUnitUseCase.execute(event.unitToBeSaved);

    if (saveUnitResult.isLeft) {
      navigationBloc.add(
        ShowException(exception: saveUnitResult.left),
      );
    } else {
      add(
        FetchUnitsAfterUnitSaving(
          unitGroup: event.unitGroup,
          modifiedUnit: saveUnitResult.right,
          rebuildConversion: event.conversionGroupId == event.prevUnitGroupId,
        ),
      );
    }
  }

  _onUnitsRemove(
    RemoveUnits event,
    Emitter<UnitsState> emit,
  ) async {
    final result = await removeUnitsUseCase.execute(event.ids);
    if (result.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: result.left,
        ),
      );
    } else {
      add(
        FetchUnitsAfterUnitsRemoval(
          unitGroup: event.unitGroup,
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
    UnitsFetched currentState = state as UnitsFetched;
    emit(
      UnitsFetched(
        units: currentState.units,
        unitGroup: currentState.unitGroup,
        searchString: currentState.searchString,
        removalMode: false,
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
