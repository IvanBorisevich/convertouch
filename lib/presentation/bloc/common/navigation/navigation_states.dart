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
  final PageName? nextPageName;
  final bool navigateBack;
  final bool navigateBackToRoot;
  final ConvertouchException? exception;
  final bool isReplaced;
  final bool closeUiElements;

  const NavigationDone({
    this.nextPageName,
    this.navigateBack = false,
    this.navigateBackToRoot = false,
    this.exception,
    this.isReplaced = false,
    this.closeUiElements = false,
  });

  @override
  List<Object?> get props => [
        nextPageName,
        navigateBack,
        navigateBackToRoot,
        exception,
        isReplaced,
        closeUiElements,
      ];

  @override
  String toString() {
    return 'NavigationDone{'
        'nextPageName: $nextPageName, '
        'navigateBack: $navigateBack, '
        'navigateBackToRoot: $navigateBackToRoot, '
        'isReplaced: $isReplaced, '
        'closeUiElements: $closeUiElements, '
        'exception: $exception}';
  }
}
