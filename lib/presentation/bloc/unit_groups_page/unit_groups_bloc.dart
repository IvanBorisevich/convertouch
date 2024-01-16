import 'package:convertouch/domain/use_cases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';

class UnitGroupsBloc extends ConvertouchBloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final AddUnitGroupUseCase addUnitGroupUseCase;
  final RemoveUnitGroupsUseCase removeUnitGroupsUseCase;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.addUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
  }) : super(const UnitGroupsFetched(unitGroups: []));

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    yield const UnitGroupsFetching();

    if (event is FetchUnitGroups) {
      final result = await fetchUnitGroupsUseCase.execute(event.searchString);

      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
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

          yield UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removalMode: true,
            markedIdsForRemoval: markedIds,
          );
        } else {
          yield UnitGroupsFetched(
            unitGroups: result.right,
            searchString: event.searchString,
            removedIds: event.removedIds,
            addedId: event.addedId,
          );
        }
      }
    } else if (event is RemoveUnitGroups) {
      final result = await removeUnitGroupsUseCase.execute(event.ids);
      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
        );
      } else {
        add(
          FetchUnitGroups(
            searchString: null,
            removedIds: event.ids,
          ),
        );
      }
    } else if (event is AddUnitGroup) {
      final addUnitGroupResult =
          await addUnitGroupUseCase.execute(event.unitGroupName);

      if (addUnitGroupResult.isLeft) {
        yield UnitGroupsErrorState(
          message: addUnitGroupResult.left.message,
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
          yield UnitGroupExists(
            unitGroupName: event.unitGroupName,
          );
        }
      }
    } else if (event is DisableUnitGroupsRemovalMode) {
      add(
        const FetchUnitGroups(
          searchString: null,
        ),
      );
    }
  }
}
