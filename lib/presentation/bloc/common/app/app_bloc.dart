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
    on<ChangeSetting>(_onSettingSave);
  }

  _onInitialSettingsGet(
    GetAppSettingsInit event,
    Emitter<AppState> emit,
  ) async {
    Map<String, dynamic> currentStateMap = toJson(state);
    String appVersion = await _getAppVersion();

    currentStateMap.update(
      SettingKeys.appVersion,
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

  _onSettingSave(
    ChangeSetting event,
    Emitter<AppState> emit,
  ) async {
    Map<String, dynamic> currentStateMap = toJson(state);

    currentStateMap.update(
      event.settingKey,
      (value) => event.settingValue,
      ifAbsent: () => event.settingValue,
    );

    emit(fromJson(currentStateMap));
  }

  @override
  AppState fromJson(Map<String, dynamic> json) {
    return AppStateReady(
      theme: ConvertouchUITheme.valueOf(json[SettingKeys.theme]),
      unitGroupsViewMode:
          ItemsViewMode.valueOf(json[SettingKeys.unitGroupsViewMode]),
      unitsViewMode: ItemsViewMode.valueOf(json[SettingKeys.unitsViewMode]),
      appVersion: json[SettingKeys.appVersion] ?? unknownAppVersion,
    );
  }

  @override
  Map<String, dynamic> toJson(AppState state) {
    if (state is AppStateReady) {
      return {
        SettingKeys.theme: state.theme.value,
        SettingKeys.unitGroupsViewMode: state.unitGroupsViewMode.value,
        SettingKeys.unitsViewMode: state.unitsViewMode.value,
        SettingKeys.appVersion: state.appVersion,
      };
    }
    return const {};
  }
}
