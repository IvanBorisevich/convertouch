import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc
    extends ConvertouchBloc<ConvertouchEvent, NavigationState> {
  NavigationBloc()
      : super(
          const NavigationDone(
            bottomNavbarItem: BottomNavbarItem.home,
            index: 0,
          ),
        ) {
    on<SelectBottomNavbarItem>(_onBottomNavbarItemSelect);
    on<NavigateToPage>(_onNavigateToPage);
    on<NavigateBack>(_onNavigateBack);
    on<NavigateBackToRootPage>(_onNavigateBackToRootPage);
    on<ShowException>(_onShowException);
  }

  _onBottomNavbarItemSelect(
    SelectBottomNavbarItem event,
    Emitter<NavigationState> emit,
  ) async {
    NavigationDone prev = state as NavigationDone;
    List<BottomNavbarItem> openedNavbarItems =
        prev.openedNavbarItems.isNotEmpty ? prev.openedNavbarItems : [];
    bool isBottomNavbarOpenedFirstTime = false;

    if (!openedNavbarItems.contains(event.bottomNavbarItem)) {
      isBottomNavbarOpenedFirstTime = true;
      openedNavbarItems.add(event.bottomNavbarItem);
    }
    emit(
      NavigationDone(
        bottomNavbarItem: event.bottomNavbarItem,
        index: event.bottomNavbarItem.index,
        openedNavbarItems: openedNavbarItems,
        isBottomNavbarOpenedFirstTime: isBottomNavbarOpenedFirstTime,
      ),
    );
  }

  _onNavigateToPage(
    NavigateToPage event,
    Emitter<NavigationState> emit,
  ) async {
    NavigationDone prev = state as NavigationDone;
    emit(
      NavigationDone(
        bottomNavbarItem: prev.bottomNavbarItem,
        index: prev.index,
        nextPageName: event.pageName,
        openedNavbarItems: prev.openedNavbarItems,
        isBottomNavbarOpenedFirstTime: prev.isBottomNavbarOpenedFirstTime,
      ),
    );
  }

  _onNavigateBack(
    NavigateBack event,
    Emitter<NavigationState> emit,
  ) async {
    NavigationDone prev = state as NavigationDone;
    emit(const NavigationInProgress());
    emit(
      NavigationDone(
        bottomNavbarItem: prev.bottomNavbarItem,
        index: prev.index,
        navigateBack: true,
        openedNavbarItems: prev.openedNavbarItems,
        isBottomNavbarOpenedFirstTime: prev.isBottomNavbarOpenedFirstTime,
      ),
    );
  }

  _onNavigateBackToRootPage(
    NavigateBackToRootPage event,
    Emitter<NavigationState> emit,
  ) async {
    NavigationDone prev = state as NavigationDone;
    emit(
      NavigationDone(
        bottomNavbarItem: prev.bottomNavbarItem,
        index: prev.index,
        navigateBack: true,
        navigateBackToRoot: true,
        openedNavbarItems: prev.openedNavbarItems,
        isBottomNavbarOpenedFirstTime: prev.isBottomNavbarOpenedFirstTime,
      ),
    );
  }

  _onShowException(
    ShowException event,
    Emitter<NavigationState> emit,
  ) async {
    NavigationDone prev = state as NavigationDone;
    emit(
      NavigationDone(
        bottomNavbarItem: prev.bottomNavbarItem,
        index: prev.index,
        navigateBack: false,
        exception: event.exception,
        openedNavbarItems: prev.openedNavbarItems,
        isBottomNavbarOpenedFirstTime: prev.isBottomNavbarOpenedFirstTime,
      ),
    );
  }
}
