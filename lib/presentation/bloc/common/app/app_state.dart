import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateInProgress extends AppState {
  const AppStateInProgress();

  @override
  String toString() {
    return 'AppStateInProgress{}';
  }
}

class AppStateReady extends AppState {
  final ConvertouchUITheme theme;
  final ItemsViewMode unitGroupsViewMode;
  final ItemsViewMode unitsViewMode;

  const AppStateReady({
    this.theme = ConvertouchUITheme.light,
    this.unitGroupsViewMode = ItemsViewMode.grid,
    this.unitsViewMode = ItemsViewMode.grid,
  });

  @override
  List<Object?> get props => [
    theme,
    unitGroupsViewMode,
    unitsViewMode,
  ];

  @override
  String toString() {
    return 'AppStateReady{'
        'theme: $theme, '
        'unitGroupsViewMode: $unitGroupsViewMode, '
        'unitsViewMode: $unitsViewMode}';
  }
}

class AppErrorState extends ConvertouchErrorState implements AppState {
  const AppErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'AppErrorState{'
        'exception: $exception, '
        'lastSuccessfulState: $lastSuccessfulState}';
  }
}
