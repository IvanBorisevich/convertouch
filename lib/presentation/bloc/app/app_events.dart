import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class SelectItemForRemoval extends AppEvent {
  final int itemId;
  final List<int>? currentSelectedItemIdsForRemoval;
  final ConvertouchUITheme uiTheme;

  const SelectItemForRemoval({
    required this.itemId,
    this.currentSelectedItemIdsForRemoval,
    this.uiTheme = ConvertouchUITheme.light,
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
  final ConvertouchUITheme uiTheme;

  const DisableRemovalMode({
    this.uiTheme = ConvertouchUITheme.light,
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
  final ConvertouchUITheme targetUiTheme;
  final int? itemIdToBeRemoved;
  final List<int>? currentSelectedItemIdsForRemoval;
  final bool removalMode;

  const ChangeUiTheme({
    required this.targetUiTheme,
    this.itemIdToBeRemoved,
    this.currentSelectedItemIdsForRemoval,
    this.removalMode = false,
  });

  @override
  List<Object?> get props => [
    targetUiTheme,
    itemIdToBeRemoved,
    currentSelectedItemIdsForRemoval,
    removalMode,
  ];

  @override
  String toString() {
    return 'ChangeUiTheme{targetUiTheme: $targetUiTheme}';
  }
}
