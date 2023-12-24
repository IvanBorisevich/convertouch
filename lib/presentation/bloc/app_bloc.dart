import 'package:convertouch/domain/model/input/app_event.dart';
import 'package:convertouch/domain/model/output/app_state.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class AppBloc extends ConvertouchBloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateBuilt());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    yield const AppStateInBuilding();

    bool removalMode = false;
    List<int> selectedItemIdsForRemoval = [];

    if (event is SelectMenuItemForRemoval) {
      if (event.selectedItemIdsForRemoval.isNotEmpty) {
        selectedItemIdsForRemoval = event.selectedItemIdsForRemoval;
      }

      if (!selectedItemIdsForRemoval.contains(event.itemId)) {
        selectedItemIdsForRemoval.add(event.itemId);
      } else {
        selectedItemIdsForRemoval.remove(event.itemId);
      }

      removalMode = true;
    } else if (event is DisableRemovalMode) {
      removalMode = false;
    }

    yield AppStateBuilt(
      removalMode: removalMode,
      selectedItemIdsForRemoval: selectedItemIdsForRemoval,
      theme: event.theme,
    );
  }
}
