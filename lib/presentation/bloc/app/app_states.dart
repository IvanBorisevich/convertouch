import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class AppState extends ConvertouchBlocState {
  const AppState();
}

class AppStateChanged extends AppState {
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme uiTheme;

  const AppStateChanged({
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
    this.uiTheme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    removalMode,
    selectedItemIdsForRemoval,
    uiTheme,
  ];

  @override
  String toString() {
    return 'AppStateChanged{'
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'uiTheme: $uiTheme'
        '}';
  }
}

class AppStateChanging extends AppState {
  const AppStateChanging();

  @override
  String toString() {
    return 'AppStateChanging{}';
  }
}

