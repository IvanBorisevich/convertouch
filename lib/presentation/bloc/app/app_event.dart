import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

class ConvertouchAppEvent extends Equatable {
  final BottomNavbarItem activeNavbarItem;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const ConvertouchAppEvent({
    required this.activeNavbarItem,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    activeNavbarItem,
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'ConvertouchAppEvent{'
        'activeNavbarItem: $activeNavbarItem, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}

class SelectMenuItemForRemoval extends ConvertouchAppEvent {
  final int itemId;

  const SelectMenuItemForRemoval({
    required this.itemId,
    super.activeNavbarItem = BottomNavbarItem.unitsMenu,
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

class DisableRemovalMode extends ConvertouchAppEvent {
  const DisableRemovalMode({
    super.activeNavbarItem = BottomNavbarItem.unitsMenu,
  });

  @override
  String toString() {
    return 'DisableRemovalMode{}';
  }
}
