import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_events.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreenBloc extends ConvertouchBloc<RootScreenEvent, RootScreenState> {
  RootScreenBloc()
      : super(
          const RootScreenState(
            selectedNavbarItem: BottomNavbarItem.home,
            index: 0,
          ),
        ) {
    on<SelectBottomNavbarItem>(_onBottomNavbarItemSelect);
  }

  _onBottomNavbarItemSelect(
    SelectBottomNavbarItem event,
    Emitter<RootScreenState> emit,
  ) async {
    List<BottomNavbarItem> openedNavbarItems =
        state.openedNavbarItems.isNotEmpty ? state.openedNavbarItems : [];
    bool isBottomNavbarOpenedFirstTime = false;

    if (!openedNavbarItems.contains(event.targetItem)) {
      isBottomNavbarOpenedFirstTime = true;
      openedNavbarItems.add(event.targetItem);
    }
    emit(
      RootScreenState(
        selectedNavbarItem: event.targetItem,
        index: event.targetItem.index,
        openedNavbarItems: openedNavbarItems,
        isBottomNavbarOpenedFirstTime: isBottomNavbarOpenedFirstTime,
      ),
    );
  }
}
