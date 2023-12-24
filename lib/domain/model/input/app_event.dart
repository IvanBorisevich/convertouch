import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/abstract_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const AppEvent({
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'AppEvent{'
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}

class SelectMenuItemForRemoval extends AppEvent {
  final int itemId;

  const SelectMenuItemForRemoval({
    required this.itemId,
    super.selectedItemIdsForRemoval,
  });

  @override
  List<Object?> get props => [
    itemId,
    super.props,
  ];

  @override
  String toString() {
    return 'SelectMenuItemForRemoval{'
        'itemId: $itemId, '
        '${super.toString()}}';
  }
}

class DisableRemovalMode extends AppEvent {
  const DisableRemovalMode();

  @override
  String toString() {
    return 'DisableRemovalMode{}';
  }
}
