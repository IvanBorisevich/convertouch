import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/use_cases/settings/get_settings_use_case.dart';
import 'package:convertouch/domain/use_cases/settings/save_settings_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends ConvertouchPersistentBloc<AppEvent, AppState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  AppBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(
          const AppStateReady(
            theme: ConvertouchUITheme.light,
            unitGroupsViewMode: ItemsViewMode.grid,
            unitsViewMode: ItemsViewMode.grid,
          ),
        ) {
    on<GetAppSettings>(_onAppSettingsGet);
    on<ChangeSetting>(_onSettingSave);
  }

  _onAppSettingsGet(
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
    );
  }

  @override
  Map<String, dynamic> toJson(AppState state) {
    if (state is AppStateReady) {
      return {
        SettingKeys.theme: state.theme.value,
        SettingKeys.unitGroupsViewMode: state.unitGroupsViewMode.value,
        SettingKeys.unitsViewMode: state.unitsViewMode.value,
      };
    }
    return const {};
  }
}
