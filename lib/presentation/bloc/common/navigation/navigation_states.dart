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
  final BottomNavbarItem bottomNavbarItem;
  final int index;
  final PageName? nextPageName;
  final bool navigateBack;
  final bool navigateBackToRoot;
  final ConvertouchException? exception;

  const NavigationDone({
    required this.bottomNavbarItem,
    required this.index,
    this.nextPageName,
    this.navigateBack = false,
    this.navigateBackToRoot = false,
    this.exception,
  });

  @override
  List<Object?> get props => [
    bottomNavbarItem,
    index,
    nextPageName,
    navigateBack,
    navigateBackToRoot,
    exception,
  ];

  @override
  String toString() {
    return 'NavigationDone{'
        'bottomNavbarItem: $bottomNavbarItem, '
        'index: $index, '
        'nextPageName: $nextPageName, '
        'navigateBack: $navigateBack, '
        'navigateBackToRoot: $navigateBackToRoot, '
        'exception: $exception}';
  }
}