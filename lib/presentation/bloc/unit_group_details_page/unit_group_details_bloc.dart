import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupDetailsBloc
    extends ConvertouchBloc<ConvertouchEvent, UnitGroupDetailsState> {
  final NavigationBloc navigationBloc;

  UnitGroupDetailsBloc({
    required this.navigationBloc,
  }) : super(
          const UnitGroupDetailsReady(
            savedGroup: UnitGroupModel.none,
            draftGroup: UnitGroupModel.none,
            isExistingGroup: false,
            canChangesBeSaved: false,
          ),
        ) {
    on<GetNewUnitGroupDetails>(_onNewUnitGroupDetailsGet);
    on<GetExistingUnitGroupDetails>(_onExistingUnitGroupDetailsGet);
    on<UpdateUnitGroupName>(_onUnitGroupNameUpdate);
  }

  _onNewUnitGroupDetailsGet(
    GetNewUnitGroupDetails event,
    Emitter<UnitGroupDetailsState> emit,
  ) async {
    emit(
      const UnitGroupDetailsReady(
        savedGroup: UnitGroupModel.none,
        draftGroup: UnitGroupModel.none,
        isExistingGroup: false,
        canChangesBeSaved: false,
      ),
    );
    navigationBloc.add(
      const NavigateToPage(pageName: PageName.unitGroupDetailsPage),
    );
  }

  _onExistingUnitGroupDetailsGet(
    GetExistingUnitGroupDetails event,
    Emitter<UnitGroupDetailsState> emit,
  ) async {
    emit(
      UnitGroupDetailsReady(
        savedGroup: event.unitGroup,
        draftGroup: event.unitGroup,
        isExistingGroup: true,
        canChangesBeSaved: false,
      ),
    );

    navigationBloc.add(
      const NavigateToPage(
        pageName: PageName.unitGroupDetailsPage,
      ),
    );
  }

  _onUnitGroupNameUpdate(
    UpdateUnitGroupName event,
    Emitter<UnitGroupDetailsState> emit,
  ) async {
    UnitGroupDetailsReady currentState = state as UnitGroupDetailsReady;
    UnitGroupModel savedGroup = currentState.savedGroup;
    UnitGroupModel draftGroup = currentState.draftGroup.copyWith(
      name: event.newValue,
    );

    emit(
      UnitGroupDetailsReady(
        savedGroup: savedGroup,
        draftGroup: draftGroup,
        isExistingGroup: savedGroup != UnitGroupModel.none,
        canChangesBeSaved: await _checkIfChangesCanBeSaved(
          savedGroup: savedGroup,
          draftGroup: draftGroup,
        ),
      ),
    );
  }

  Future<bool> _checkIfChangesCanBeSaved({
    required UnitGroupModel savedGroup,
    required UnitGroupModel draftGroup,
  }) async {
    String newGroupName =
        draftGroup.name.isNotEmpty ? draftGroup.name : savedGroup.name;

    return newGroupName != savedGroup.name;
  }
}
