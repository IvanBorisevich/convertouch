import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/app_event.dart';
import 'package:convertouch/domain/model/output/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchAppBloc
    extends Bloc<ConvertouchAppEvent, ConvertouchAppState> {
  ConvertouchAppBloc() : super(const ConvertouchAppStateBuilt(
    activeNavbarItem: BottomNavbarItem.home,
  ));

  @override
  Stream<ConvertouchAppState> mapEventToState(
    ConvertouchAppEvent event,
  ) async* {
    yield const ConvertouchAppStateInBuilding();

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

    yield ConvertouchAppStateBuilt(
      activeNavbarItem: event.activeNavbarItem,
      removalMode: removalMode,
      selectedItemIdsForRemoval: selectedItemIdsForRemoval,
      theme: event.theme,
    );
  }
}
