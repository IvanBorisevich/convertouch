import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/save_unit_group_use_case.dart';
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
  final NavigationBloc navigationBloc;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.saveUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
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
        List<int> markedIds = [];

        if (event.alreadyMarkedIds.isNotEmpty) {
          markedIds = event.alreadyMarkedIds;
        }

        if (!markedIds.contains(event.newMarkedId)) {
          markedIds.add(event.newMarkedId);
        } else {
          markedIds.remove(event.newMarkedId);
        }

        List<int> oobUnitGroupIds = [];
        bool customGroupsExist = false;

        for (final unitGroup in result.right) {
          if (unitGroup.oob) {
            oobUnitGroupIds.add(unitGroup.id!);
          } else {
            customGroupsExist = true;
            continue;
          }
        }

        markedIds = markedIds
            .whereNot((unitGroupId) => oobUnitGroupIds.contains(unitGroupId))
            .toList();

        emit(const UnitGroupsFetching());
        emit(
          UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removalMode: customGroupsExist,
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
      if (saveUnitGroupResult.right != null) {
        add(
          FetchUnitGroups(
            searchString: null,
            modifiedUnitGroup: saveUnitGroupResult.right,
            rebuildConversion:
                event.conversionGroupId == saveUnitGroupResult.right!.id,
          ),
        );
        navigationBloc.add(
          const NavigateBack(),
        );
      } else {
        navigationBloc.add(
          ShowException(
            exception: ConvertouchException(
              message: "Unit group [${event.unitGroupToBeSaved.name}] "
                  "already exists",
              severity: ExceptionSeverity.warning,
              stackTrace: null,
            ),
          ),
        );
      }
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
