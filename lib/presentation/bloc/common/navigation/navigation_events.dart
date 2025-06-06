import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class NavigationEvent extends ConvertouchEvent {
  const NavigationEvent();
}

class SelectBottomNavbarItem extends NavigationEvent {
  final BottomNavbarItem targetItem;
  final BottomNavbarItem selectedItem;

  const SelectBottomNavbarItem({
    required this.targetItem,
    required this.selectedItem,
  });

  @override
  List<Object?> get props => [
        targetItem,
        selectedItem,
      ];

  @override
  String toString() {
    return 'SelectBottomNavbarItem{'
        'targetItem: $targetItem, '
        'selectedItem: $selectedItem}';
  }
}

class NavigateToPage extends NavigationEvent {
  final PageName pageName;

  const NavigateToPage({
    required this.pageName,
  });

  @override
  List<Object?> get props => [
        pageName,
      ];

  @override
  String toString() {
    return 'NavigateToPage{pageName: $pageName}';
  }
}

class ShowException extends NavigationEvent {
  final ConvertouchException exception;

  const ShowException({
    required this.exception,
  });

  @override
  List<Object?> get props => [
        exception,
      ];

  @override
  String toString() {
    return 'ShowException{exception: $exception}';
  }
}

class NavigateBack extends NavigationEvent {
  const NavigateBack();

  @override
  String toString() {
    return 'NavigateBack{}';
  }
}

class NavigateBackToRootPage extends NavigationEvent {
  const NavigateBackToRootPage();

  @override
  String toString() {
    return 'NavigateBackToRootPage{}';
  }
}
