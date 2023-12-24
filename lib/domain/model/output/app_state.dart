import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/output/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateInBuilding extends AppState {
  const AppStateInBuilding();

  @override
  String toString() {
    return 'AppStateInBuilding{}';
  }
}

class AppStateBuilt extends AppState {
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const AppStateBuilt({
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    removalMode,
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'AppStateBuilt{'
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}
