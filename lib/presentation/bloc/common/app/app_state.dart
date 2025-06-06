import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateReady extends AppState {
  final ConvertouchUITheme theme;
  final ItemsViewMode unitGroupsViewMode;
  final ItemsViewMode unitsViewMode;
  final ItemsViewMode paramSetsViewMode;
  final UnitTapAction unitTapAction;
  final RecalculationOnUnitChange recalculationOnUnitChange;
  final PageName? changedFromPage;
  final String appVersion;

  const AppStateReady({
    required this.theme,
    required this.unitGroupsViewMode,
    required this.unitsViewMode,
    required this.paramSetsViewMode,
    required this.unitTapAction,
    required this.recalculationOnUnitChange,
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
        unitTapAction,
        recalculationOnUnitChange,
        appVersion,
      ];

  Map<String, dynamic> toJson() {
    return {
      SettingKey.theme.name: theme.value,
      SettingKey.unitGroupsViewMode.name: unitGroupsViewMode.value,
      SettingKey.unitsViewMode.name: unitsViewMode.value,
      SettingKey.paramSetsViewMode.name: paramSetsViewMode.value,
      SettingKey.appVersion.name: appVersion,
      SettingKey.conversionUnitTapAction.name: unitTapAction.id,
      SettingKey.recalculationOnUnitChange.name: recalculationOnUnitChange.id,
    };
  }

  static AppStateReady fromJson(Map<String, dynamic>? json) {
    return AppStateReady(
      theme: ConvertouchUITheme.valueOf(json?[SettingKey.theme.name]),
      unitGroupsViewMode:
          ItemsViewMode.valueOf(json?[SettingKey.unitGroupsViewMode.name]),
      unitsViewMode:
          ItemsViewMode.valueOf(json?[SettingKey.unitsViewMode.name]),
      paramSetsViewMode:
          ItemsViewMode.valueOf(json?[SettingKey.paramSetsViewMode.name]),
      unitTapAction:
          UnitTapAction.valueOf(json?[SettingKey.conversionUnitTapAction.name]),
      recalculationOnUnitChange: RecalculationOnUnitChange.valueOf(
          json?[SettingKey.recalculationOnUnitChange.name]),
      appVersion: json?[SettingKey.appVersion.name] ?? unknownAppVersion,
      changedFromPage: json?['changedFromPage'],
    );
  }

  @override
  String toString() {
    return 'AppStateReady{'
        'theme: $theme, '
        'unitGroupsViewMode: $unitGroupsViewMode, '
        'unitsViewMode: $unitsViewMode, '
        'paramSetsViewMode: $paramSetsViewMode, '
        'unitTapAction: $unitTapAction, '
        'recalculationOnUnitChange: $recalculationOnUnitChange, '
        'changedFromPage: $changedFromPage, '
        'appVersion: $appVersion}';
  }
}
