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
    switch (event.bottomNavbarItem) {
      case BottomNavbarItem.home:
        emit(
          const NavigationDone(
            bottomNavbarItem: BottomNavbarItem.home,
            index: 0,
          ),
        );
        break;
      case BottomNavbarItem.unitsMenu:
        emit(
          const NavigationDone(
            bottomNavbarItem: BottomNavbarItem.unitsMenu,
            index: 1,
          ),
        );
        break;
      case BottomNavbarItem.settings:
        emit(
          const NavigationDone(
            bottomNavbarItem: BottomNavbarItem.settings,
            index: 2,
          ),
        );
        break;
    }
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
      ),
    );
  }
}
