import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateReady extends AppState {
  final ConvertouchUITheme theme;
  final ItemsViewMode unitGroupsViewMode;
  final ItemsViewMode unitsViewMode;
  final String appVersion;

  const AppStateReady({
    required this.theme,
    required this.unitGroupsViewMode,
    required this.unitsViewMode,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [
    theme,
    unitGroupsViewMode,
    unitsViewMode,
    appVersion,
  ];

  @override
  String toString() {
    return 'AppStateReady{'
        'theme: $theme, '
        'unitGroupsViewMode: $unitGroupsViewMode, '
        'unitsViewMode: $unitsViewMode, '
        'appVersion: $appVersion}';
  }
}
