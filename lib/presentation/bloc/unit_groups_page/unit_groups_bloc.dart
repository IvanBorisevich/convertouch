import 'package:convertouch/domain/model/use_case_model/input/input_items_for_removal_model.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/common/mark_items_for_removal_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/save_unit_group_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc
    extends ConvertouchBloc<ConvertouchEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final SaveUnitGroupUseCase saveUnitGroupUseCase;
  final RemoveUnitGroupsUseCase removeUnitGroupsUseCase;
  final MarkItemsForRemovalUseCase markItemsForRemovalUseCase;
  final NavigationBloc navigationBloc;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.saveUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
    required this.markItemsForRemovalUseCase,
    required this.navigationBloc,
  }) : super(const UnitGroupsFetched(unitGroups: [])) {
    on<FetchUnitGroups>(_onUnitGroupsFetch);
    on<RemoveUnitGroups>(_onUnitGroupsRemove);
    on<SaveUnitGroup>(_onUnitGroupSave);
    on<DisableUnitGroupsRemovalMode>(_onUnitGroupsRemovalModeDisable);
  }

  _onUnitGroupsFetch(
    FetchUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    UnitGroupsFetched currentState = state as UnitGroupsFetched;

    final result = await fetchUnitGroupsUseCase.execute(event.searchString);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      if (event is FetchUnitGroupsToMarkForRemoval) {
        final markedIdsResult = await markItemsForRemovalUseCase.execute(
          InputItemsForRemovalModel(
            newMarkedId: event.newMarkedId,
            alreadyMarkedIds: event.alreadyMarkedIds,
            oobIds: result.right.where((e) => e.oob).map((e) => e.id!).toList(),
          ),
        );

        final markedIds = ObjectUtils.tryGet(markedIdsResult).markedIds;

        emit(const UnitGroupsFetching());
        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removalMode: markedIds.isNotEmpty,
            markedIdsForRemoval: markedIds,
          ),
        );
      } else if (event is FetchUnitGroupsAfterRemoval) {
        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removalMode: false,
            rebuildConversion: event.rebuildConversion,
            removedIds: event.removedIds,
          ),
        );
      } else {
        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            modifiedUnitGroup: event.modifiedUnitGroup,
            rebuildConversion: event.rebuildConversion,
            removalMode: currentState.removalMode,
            markedIdsForRemoval: currentState.markedIdsForRemoval,
          ),
        );
      }
    }
  }

  _onUnitGroupsRemove(
    RemoveUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    UnitGroupsFetched currentState = state as UnitGroupsFetched;

    final result = await removeUnitGroupsUseCase.execute(event.ids);
    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      add(
        FetchUnitGroupsAfterRemoval(
          searchString: currentState.searchString,
          removedIds: event.ids,
          rebuildConversion: event.ids.isNotEmpty,
        ),
      );
    }
  }

  _onUnitGroupSave(
    SaveUnitGroup event,
    Emitter<UnitGroupsState> emit,
  ) async {
    final saveUnitGroupResult =
        await saveUnitGroupUseCase.execute(event.unitGroupToBeSaved);

    if (saveUnitGroupResult.isLeft) {
      navigationBloc.add(
        ShowException(exception: saveUnitGroupResult.left),
      );
    } else {
      add(
        FetchUnitGroups(
          searchString: null,
          modifiedUnitGroup: saveUnitGroupResult.right,
          rebuildConversion:
              event.conversionGroupId == saveUnitGroupResult.right.id,
        ),
      );
      navigationBloc.add(
        const NavigateBack(),
      );
    }
  }

  _onUnitGroupsRemovalModeDisable(
    DisableUnitGroupsRemovalMode event,
    Emitter<UnitGroupsState> emit,
  ) async {
    UnitGroupsFetched currentState = state as UnitGroupsFetched;
    emit(
      UnitGroupsFetched(
        unitGroups: currentState.unitGroups,
        searchString: currentState.searchString,
        removalMode: false,
      ),
    );
  }
}
