import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class NavigationEvent extends ConvertouchEvent {
  final bool closeUiElements;

  const NavigationEvent({
    this.closeUiElements = false,
  });

  @override
  List<Object?> get props => [
        closeUiElements,
      ];
}

class NavigateToPage extends NavigationEvent {
  final PageName targetPageName;
  final bool replace;

  const NavigateToPage({
    required this.targetPageName,
    this.replace = false,
    super.closeUiElements,
  });

  @override
  List<Object?> get props => [
        targetPageName,
        replace,
        super.props,
      ];

  @override
  String toString() {
    return 'NavigateToPage{'
        'pageName: $targetPageName, '
        'replace: $replace, '
        'closeUiElements: $closeUiElements}';
  }
}

class ShowException extends NavigationEvent {
  final ConvertouchException exception;

  const ShowException({
    required this.exception,
    super.closeUiElements,
  });

  @override
  List<Object?> get props => [
        exception,
        super.props,
      ];

  @override
  String toString() {
    return 'ShowException{'
        'exception: $exception, '
        'closeUiElements: $closeUiElements}';
  }
}

class NavigateBack extends NavigationEvent {
  const NavigateBack({
    super.closeUiElements,
  });

  @override
  String toString() {
    return 'NavigateBack{closeUiElements: $closeUiElements}';
  }
}

class NavigateBackToRootPage extends NavigationEvent {
  const NavigateBackToRootPage({
    super.closeUiElements,
  });

  @override
  String toString() {
    return 'NavigateBackToRootPage{closeUiElements: $closeUiElements}';
  }
}
