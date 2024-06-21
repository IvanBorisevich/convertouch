import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class NavigationState extends ConvertouchState {
  const NavigationState();
}

class NavigationInProgress extends NavigationState {
  const NavigationInProgress();

  @override
  String toString() {
    return 'NavigationInProgress{}';
  }
}

class NavigationDone extends NavigationState {
  final BottomNavbarItem selectedNavbarItem;
  final int index;
  final PageName? nextPageName;
  final bool navigateBack;
  final bool navigateBackToRoot;
  final ConvertouchException? exception;
  final List<BottomNavbarItem> openedNavbarItems;
  final bool isBottomNavbarOpenedFirstTime;

  const NavigationDone({
    required this.selectedNavbarItem,
    required this.index,
    this.nextPageName,
    this.navigateBack = false,
    this.navigateBackToRoot = false,
    this.exception,
    this.openedNavbarItems = const [],
    this.isBottomNavbarOpenedFirstTime = false,
  });

  @override
  List<Object?> get props => [
    selectedNavbarItem,
    index,
    nextPageName,
    navigateBack,
    navigateBackToRoot,
    exception,
    openedNavbarItems,
    isBottomNavbarOpenedFirstTime,
  ];

  @override
  String toString() {
    return 'NavigationDone{'
        'selectedNavbarItem: $selectedNavbarItem, '
        'index: $index, '
        'nextPageName: $nextPageName, '
        'navigateBack: $navigateBack, '
        'navigateBackToRoot: $navigateBackToRoot, '
        'openedNavbarItems: $openedNavbarItems, '
        'isBottomNavbarOpenedFirstTime: $isBottomNavbarOpenedFirstTime, '
        'exception: $exception}';
  }
}