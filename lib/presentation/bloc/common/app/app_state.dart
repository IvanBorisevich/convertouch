import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateReady extends AppState {
  final ConvertouchUITheme theme;
  final ItemsViewMode unitGroupsViewMode;
  final ItemsViewMode unitsViewMode;
  final ItemsViewMode paramSetsViewMode;
  final PageName? changedFromPage;
  final String appVersion;

  const AppStateReady({
    required this.theme,
    required this.unitGroupsViewMode,
    required this.unitsViewMode,
    required this.paramSetsViewMode,
    this.changedFromPage,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [
    theme,
    unitGroupsViewMode,
    unitsViewMode,
    paramSetsViewMode,
    changedFromPage,
    appVersion,
  ];

  @override
  String toString() {
    return 'AppStateReady{'
        'theme: $theme, '
        'unitGroupsViewMode: $unitGroupsViewMode, '
        'unitsViewMode: $unitsViewMode, '
        'paramSetsViewMode: $paramSetsViewMode, '
        'changedFromPage: $changedFromPage, '
        'appVersion: $appVersion}';
  }
}
