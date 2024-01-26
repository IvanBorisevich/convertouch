import 'package:collection/collection.dart';
import 'package:convertouch/domain/use_cases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc extends ConvertouchBloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final AddUnitGroupUseCase addUnitGroupUseCase;
  final RemoveUnitGroupsUseCase removeUnitGroupsUseCase;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.addUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
  }) : super(const UnitGroupsFetched(unitGroups: [])) {
    on<FetchUnitGroups>(_onUnitGroupsFetch);
    on<RemoveUnitGroups>(_onUnitGroupsRemove);
    on<AddUnitGroup>(_onUnitGroupAdd);
    on<DisableUnitGroupsRemovalMode>(_onUnitGroupsRemovalModeDisable);
  }

  _onUnitGroupsFetch(
    FetchUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    emit(const UnitGroupsFetching());
    final result = await fetchUnitGroupsUseCase.execute(event.searchString);

    if (result.isLeft) {
      emit(
        UnitGroupsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      if (event is FetchUnitGroupsToMarkForRemoval) {
        List<int> markedIds = [];

        if (event.alreadyMarkedIds.isNotEmpty) {
          markedIds = event.alreadyMarkedIds;
        }

        if (!markedIds.contains(event.newMarkedId)) {
          markedIds.add(event.newMarkedId);
        } else {
          markedIds.remove(event.newMarkedId);
        }

        List<int> oobUnitGroupIds = result.right
            .where((unitGroup) => unitGroup.oob)
            .map((unitGroup) => unitGroup.id!)
            .toList();

        markedIds = markedIds
            .whereNot((unitGroupId) => oobUnitGroupIds.contains(unitGroupId))
            .toList();

        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removalMode: true,
            markedIdsForRemoval: markedIds,
          ),
        );
      } else {
        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removedIds: event.removedIds,
            addedId: event.addedId,
          ),
        );
      }
    }
  }

  _onUnitGroupsRemove(
    RemoveUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    emit(const UnitGroupsFetching());

    final result = await removeUnitGroupsUseCase.execute(event.ids);
    if (result.isLeft) {
      emit(
        UnitGroupsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      add(
        FetchUnitGroups(
          searchString: null,
          removedIds: event.ids,
        ),
      );
    }
  }

  _onUnitGroupAdd(
    AddUnitGroup event,
    Emitter<UnitGroupsState> emit,
  ) async {
    emit(const UnitGroupsFetching());

    final addUnitGroupResult =
        await addUnitGroupUseCase.execute(event.unitGroupName);

    if (addUnitGroupResult.isLeft) {
      emit(
        UnitGroupsErrorState(
          exception: addUnitGroupResult.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      int addedUnitGroupId = addUnitGroupResult.right;

      if (addedUnitGroupId != -1) {
        add(
          FetchUnitGroups(
            searchString: null,
            addedId: addedUnitGroupId,
          ),
        );
      } else {
        emit(
          UnitGroupExists(
            unitGroupName: event.unitGroupName,
          ),
        );
      }
    }
  }

  _onUnitGroupsRemovalModeDisable(
    DisableUnitGroupsRemovalMode event,
    Emitter<UnitGroupsState> emit,
  ) async {
    add(
      const FetchUnitGroups(
        searchString: null,
      ),
    );
  }
}
