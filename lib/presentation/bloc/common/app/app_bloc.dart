import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/use_cases/settings/get_settings_use_case.dart';
import 'package:convertouch/domain/use_cases/settings/save_settings_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends ConvertouchBloc<AppEvent, AppState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  AppBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(const AppInitialState()) {
    on<GetAppSettings>(_onAppSettingsGet);
    on<ChangeSetting>(_onSettingSave);
  }

  _onAppSettingsGet(
    GetAppSettings event,
    Emitter<AppState> emit,
  ) async {
    final result = await getSettingsUseCase.execute([
      SettingKeys.theme,
      SettingKeys.unitGroupsViewMode,
      SettingKeys.unitsViewMode,
    ]);

    emit(
      result.fold(
        (error) => AppErrorState(
          exception: error,
          lastSuccessfulState: state,
        ),
        (settings) => AppStateReady(
          theme: ConvertouchUITheme.valueOf(settings[SettingKeys.theme]),
          unitGroupsViewMode:
              ItemsViewMode.valueOf(settings[SettingKeys.unitGroupsViewMode]),
          unitsViewMode:
              ItemsViewMode.valueOf(settings[SettingKeys.unitsViewMode]),
        ),
      ),
    );
  }

  _onSettingSave(
    ChangeSetting event,
    Emitter<AppState> emit,
  ) async {
    final result = await saveSettingsUseCase.execute({
      event.settingKey: event.settingValue,
    });

    if (result.isLeft) {
      emit(
        AppErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      add(const GetAppSettings());
    }
  }
}
