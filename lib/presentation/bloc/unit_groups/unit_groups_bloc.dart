import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc extends Bloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final AddUnitGroupUseCase addUnitGroupUseCase;
  final RemoveUnitGroupsUseCase removeUnitGroupsUseCase;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.addUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
  }) : super(const UnitGroupsInitState());

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    if (event is FetchUnitGroups) {
      yield const UnitGroupsFetching();

      final result = await fetchUnitGroupsUseCase.execute();
      yield result.fold(
        (error) => UnitGroupsErrorState(
          message: error.message,
        ),
        (unitGroups) => UnitGroupsFetched(
          unitGroups: unitGroups,
          selectedUnitGroupId: event.selectedUnitGroupId,
          markedUnits: event.markedUnits,
          action: event.action,
        ),
      );
    } else if (event is AddUnitGroup) {
      yield const UnitGroupsFetching();

      final addUnitGroupResult = await addUnitGroupUseCase.execute(
        UnitGroupModel(
          name: event.unitGroupName,
        ),
      );

      if (addUnitGroupResult.isLeft) {
        yield UnitGroupsErrorState(
          message: addUnitGroupResult.left.message,
        );
      } else {
        int addedUnitGroupId = addUnitGroupResult.right;
        if (addedUnitGroupId > -1) {
          final fetchUnitGroupsResult = await fetchUnitGroupsUseCase.execute();
          yield fetchUnitGroupsResult.fold(
            (error) => UnitGroupsErrorState(
              message: error.message,
            ),
            (unitGroups) => UnitGroupsFetched(
              unitGroups: unitGroups,
              addedUnitGroupId: addedUnitGroupId,
            ),
          );
        } else {
          yield UnitGroupExists(
            unitGroupName: event.unitGroupName,
          );
        }
      }
    } else if (event is SelectUnitGroup) {
      yield const UnitGroupSelecting();
      yield UnitGroupSelected(
        unitGroup: event.unitGroup,
      );
    } else if (event is RemoveUnitGroups) {
      yield const UnitGroupsFetching();
      final result = await removeUnitGroupsUseCase.execute(event.ids);
      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
        );
      } else {
        final fetchUnitGroupsResult = await fetchUnitGroupsUseCase.execute();
        yield fetchUnitGroupsResult.fold(
          (error) => UnitGroupsErrorState(
            message: error.message,
          ),
          (unitGroups) => UnitGroupsFetched(
            unitGroups: unitGroups,
            needToNavigate: false,
          ),
        );
      }
    }
  }
}
