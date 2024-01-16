import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';

class UnitsBloc extends ConvertouchBloc<UnitsEvent, UnitsState> {
  final AddUnitUseCase addUnitUseCase;
  final FetchUnitsUseCase fetchUnitsUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;

  UnitsBloc({
    required this.addUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
  }) : super(const UnitsInitialState());

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnits) {
      final result = await fetchUnitsUseCase.execute(
        InputUnitFetchModel(
          searchString: event.searchString,
          unitGroupId: event.unitGroup.id!,
        ),
      );

      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
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

          yield UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removalMode: true,
            markedIdsForRemoval: markedIds,
          );
        } else {
          yield UnitsFetched(
            units: result.right,
            unitGroup: event.unitGroup,
            searchString: event.searchString,
            removedIds: event.removedIds,
            addedId: event.addedId,
          );
        }
      }
    } else if (event is AddUnit) {
      final addUnitResult = await addUnitUseCase.execute(
        event.unitCreationParams,
      );

      if (addUnitResult.isLeft) {
        yield UnitsErrorState(
          message: addUnitResult.left.message,
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
          yield UnitExists(
            unitName: event.unitCreationParams.newUnitName,
          );
        }
      }
    } else if (event is RemoveUnits) {
      final result = await removeUnitsUseCase.execute(event.ids);
      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
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
    } else if (event is DisableUnitsRemovalMode) {
      add(
        FetchUnits(
          unitGroup: event.unitGroup,
          searchString: null,
        ),
      );
    }
  }
}
