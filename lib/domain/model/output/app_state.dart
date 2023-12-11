import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchAppState extends Equatable {
  const ConvertouchAppState();

  @override
  List<Object?> get props => [];
}

class ConvertouchAppStateInBuilding extends ConvertouchAppState {
  const ConvertouchAppStateInBuilding();

  @override
  String toString() {
    return 'ConvertouchAppStateInBuilding{}';
  }
}

class ConvertouchAppStateBuilt extends ConvertouchAppState {
  final BottomNavbarItem activeNavbarItem;
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const ConvertouchAppStateBuilt({
    required this.activeNavbarItem,
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    activeNavbarItem,
    removalMode,
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'ConvertouchAppStateBuilt{'
        'activeNavbarItem: $activeNavbarItem, '
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}
