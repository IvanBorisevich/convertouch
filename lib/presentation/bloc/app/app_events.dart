import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  final String currentPageId;
  final String? nextPageId;
  final String pageTitle;
  final bool floatingButtonVisible;
  final List<int>? currentSelectedItemIdsForRemoval;
  final ConvertouchUITheme uiTheme;

  const AppEvent({
    required this.currentPageId,
    this.nextPageId,
    required this.pageTitle,
    required this.floatingButtonVisible,
    this.currentSelectedItemIdsForRemoval,
    required this.uiTheme,
  });
}

class SelectItemForRemoval extends AppEvent {
  final int itemId;

  const SelectItemForRemoval({
    required this.itemId,
    required super.currentPageId,
    required super.nextPageId,
    required super.pageTitle,
    required super.floatingButtonVisible,
    super.currentSelectedItemIdsForRemoval,
    required super.uiTheme,
  });

  @override
  List<Object?> get props => [
    itemId,
    currentSelectedItemIdsForRemoval,
    uiTheme,
  ];

  @override
  String toString() {
    return 'SelectItemForRemoval{'
        'itemId: $itemId, '
        'currentSelectedItemIdsForRemoval: $currentSelectedItemIdsForRemoval, '
        'uiTheme: $uiTheme'
        '}';
  }
}

class DisableRemovalMode extends AppEvent {
  const DisableRemovalMode({
    required super.currentPageId,
    super.nextPageId,
    required super.pageTitle,
    required super.floatingButtonVisible,
    required super.uiTheme,
  });

  @override
  List<Object?> get props => [
    uiTheme,
  ];

  @override
  String toString() {
    return 'DisableRemovalMode{}';
  }
}

class ChangeUiTheme extends AppEvent {
  final bool removalMode;

  const ChangeUiTheme({
    required super.currentPageId,
    required super.nextPageId,
    required super.pageTitle,
    required super.floatingButtonVisible,
    required super.uiTheme,
    super.currentSelectedItemIdsForRemoval,
    required this.removalMode,
  });

  @override
  List<Object?> get props => [
    uiTheme,
    currentSelectedItemIdsForRemoval,
    removalMode,
  ];

  @override
  String toString() {
    return 'ChangeUiTheme{uiTheme: $uiTheme}';
  }
}
