import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  final List<int>? currentSelectedItemIdsForRemoval;
  final ConvertouchUITheme uiTheme;

  const AppEvent({
    this.currentSelectedItemIdsForRemoval,
    required this.uiTheme,
  });
}

class SelectItemForRemoval extends AppEvent {
  final int itemId;

  const SelectItemForRemoval({
    required this.itemId,
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
