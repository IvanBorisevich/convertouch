import 'package:convertouch/data/dao/db/unit_group_db_dao_impl.dart';
import 'package:convertouch/data/models/unit_group_model.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc extends Bloc<UnitGroupsEvent, UnitGroupsState> {
  final FetchUnitGroupsUseCase _fetchUnitGroupsUseCase;

  UnitGroupsBloc(this._fetchUnitGroupsUseCase)
      : super(const UnitGroupsInitState());

  @override
  Stream<UnitGroupsState> mapEventToState(UnitGroupsEvent event) async* {
    if (event is FetchUnitGroups) {
      yield const UnitGroupsFetching();

      final result = await _fetchUnitGroupsUseCase.execute();
      yield result.fold(
        (data) => UnitGroupsFetched(
          unitGroups: data,
          selectedUnitGroupId: event.selectedUnitGroupId,
          markedUnits: event.markedUnits,
          action: event.action,
        ),
        (error) => UnitGroupsErrorState(
          message: error.message,
        ),
      );
    } else if (event is AddUnitGroup) {
      yield const UnitGroupsFetching();

      bool unitGroupExists = allUnitGroups
          .any((unitGroup) => event.unitGroupName == unitGroup.name);

      if (!unitGroupExists) {
        UnitGroupModel newUnitGroup = UnitGroupModel(
            id: allUnitGroups.length + 1, name: event.unitGroupName);
        allUnitGroups.add(newUnitGroup);
        yield UnitGroupsFetched(
          unitGroups: allUnitGroups.map((model) => model.toEntity()).toList(),
          addedUnitGroup: newUnitGroup.toEntity(),
        );
      } else {
        yield UnitGroupExists(unitGroupName: event.unitGroupName);
      }
    } else if (event is SelectUnitGroup) {
      yield const UnitGroupSelecting();
      yield UnitGroupSelected(unitGroup: event.unitGroup);
    }
  }
}
