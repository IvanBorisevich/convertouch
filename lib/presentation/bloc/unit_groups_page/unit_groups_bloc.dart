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
  }

  _onUnitGroupsFetch(
    FetchUnitGroups event,
    Emitter<UnitGroupsState> emit,
  ) async {
    final result = await fetchUnitGroupsUseCase.execute(event.searchString);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      emit(
        UnitGroupsFetched(
          unitGroups: result.right,
          searchString: event.searchString,
        ),
      );
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
        FetchUnitGroups(
          searchString: currentState.searchString,
        ),
      );

      event.onComplete?.call();
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
        const FetchUnitGroups(),
      );

      event.onSaveGroup?.call(saveUnitGroupResult.right);
    }
  }
}

class UnitGroupsBlocForUnitDetails extends UnitGroupsBloc {
  UnitGroupsBlocForUnitDetails({
    required super.fetchUnitGroupsUseCase,
    required super.saveUnitGroupUseCase,
    required super.removeUnitGroupsUseCase,
    required super.navigationBloc,
  });
}
