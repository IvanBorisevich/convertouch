import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppBloc extends ConvertouchPersistentBloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateReady(
            theme: ConvertouchUITheme.light,
            unitGroupsViewMode: ItemsViewMode.grid,
            unitsViewMode: ItemsViewMode.grid,
            appVersion: unknownAppVersion,
          ),
        ) {
    on<GetAppSettingsInit>(_onInitialSettingsGet);
    on<GetAppSettings>(_onSettingsGet);
    on<ChangeSetting>(_onSettingChange);
  }

  _onInitialSettingsGet(
    GetAppSettingsInit event,
    Emitter<AppState> emit,
  ) async {
    Map<String, dynamic> currentStateMap = toJson(state);
    String appVersion = await _getAppVersion();

    currentStateMap.update(
      SettingKey.appVersion.name,
      (value) => appVersion,
      ifAbsent: () => appVersion,
    );

    emit(fromJson(currentStateMap));
  }

  Future<String> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    String buildNum = info.buildNumber.isNotEmpty ? "+${info.buildNumber}" : "";

    return "${info.version}$buildNum";
  }

  _onSettingsGet(
    GetAppSettings event,
    Emitter<AppState> emit,
  ) async {
    emit(state);
  }

  _onSettingChange(
    ChangeSetting event,
    Emitter<AppState> emit,
  ) async {
    Map<String, dynamic> currentStateMap = toJson(state);

    currentStateMap.update(
      event.settingKey,
      (value) => event.settingValue,
      ifAbsent: () => event.settingValue,
    );

    currentStateMap.update(
      'changedFromPage',
      (value) => event.fromPage,
      ifAbsent: () => event.fromPage,
    );

    emit(fromJson(currentStateMap));
  }

  @override
  AppState fromJson(Map<String, dynamic> json) {
    return AppStateReady(
      theme: ConvertouchUITheme.valueOf(json[SettingKey.theme.name]),
      unitGroupsViewMode:
          ItemsViewMode.valueOf(json[SettingKey.unitGroupsViewMode.name]),
      unitsViewMode: ItemsViewMode.valueOf(json[SettingKey.unitsViewMode.name]),
      appVersion: json[SettingKey.appVersion.name] ?? unknownAppVersion,
      changedFromPage: json['changedFromPage'],
    );
  }

  @override
  Map<String, dynamic> toJson(AppState state) {
    if (state is AppStateReady) {
      return {
        SettingKey.theme.name: state.theme.value,
        SettingKey.unitGroupsViewMode.name: state.unitGroupsViewMode.value,
        SettingKey.unitsViewMode.name: state.unitsViewMode.value,
        SettingKey.appVersion.name: state.appVersion,
      };
    }
    return const {};
  }
}
