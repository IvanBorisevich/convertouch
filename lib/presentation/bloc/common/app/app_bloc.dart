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
  }) : super(const AppStateReady()) {
    on<RestoreAppSettings>(_onSettingsRestore);
    on<SaveSetting>(_onSettingSave);
  }

  _onSettingsRestore(
    RestoreAppSettings event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppStateInProgress());

    final result = await getSettingsUseCase.execute([
      SettingKeys.theme,
    ]);

    emit(
      result.fold(
        (error) => AppErrorState(
          exception: error,
          lastSuccessfulState: state,
        ),
        (settings) => AppStateReady(
          theme: ConvertouchUITheme.valueOf(settings[SettingKeys.theme]),
        ),
      ),
    );
  }

  _onSettingSave(
    SaveSetting event,
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
      add(const RestoreAppSettings());
    }
  }
}
