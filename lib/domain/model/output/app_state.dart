import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppStateInBuilding extends AppState {
  const AppStateInBuilding();

  @override
  String toString() {
    return 'AppStateInBuilding{}';
  }
}

class AppStateBuilt extends AppState {
  final BottomNavbarItem activeNavbarItem;
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const AppStateBuilt({
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
    return 'AppStateBuilt{'
        'activeNavbarItem: $activeNavbarItem, '
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}
