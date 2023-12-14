import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/output/unit_groups_states.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsBloc extends Bloc<UnitGroupsEvent, UnitGroupsState> {
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
      final result = await fetchUnitGroupsUseCase.execute(event);

      yield result.fold(
        (error) => UnitGroupsErrorState(
          message: error.message,
        ),
        (unitGroups) => UnitGroupsFetched(
          unitGroups: unitGroups,
        ),
      );
    } else if (event is RemoveUnitGroups) {
      final result = await removeUnitGroupsUseCase.execute(event);
      if (result.isLeft) {
        yield UnitGroupsErrorState(
          message: result.left.message,
        );
      } else {
        add(const FetchUnitGroups(searchString: null));
      }
    } else if (event is AddUnitGroup) {
      final addUnitGroupResult = await addUnitGroupUseCase.execute(event);

      if (addUnitGroupResult.isLeft) {
        yield UnitGroupsErrorState(
          message: addUnitGroupResult.left.message,
        );
      } else {
        bool unitGroupAdded = addUnitGroupResult.right;

        if (unitGroupAdded) {
          add(const FetchUnitGroups(searchString: null));
        } else {
          yield UnitGroupExists(
            unitGroupName: event.unitGroupName,
          );
        }
      }
    }
  }
}
