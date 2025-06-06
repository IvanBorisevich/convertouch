import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class GetAppSettingsInit extends AppEvent {
  const GetAppSettingsInit();

  @override
  String toString() {
    return 'GetAppSettingsInit{}';
  }
}

class GetAppSettings extends AppEvent {
  const GetAppSettings();

  @override
  String toString() {
    return 'GetAppSettings{}';
  }
}

class ChangeSetting extends AppEvent {
  final SettingKey settingKey;
  final dynamic settingValue;
  final PageName? fromPage;

  const ChangeSetting({
    required this.settingKey,
    required this.settingValue,
    this.fromPage,
  });

  @override
  List<Object?> get props => [
        settingKey,
        settingValue,
        fromPage,
      ];

  @override
  String toString() {
    return 'ChangeSetting{'
        'settingKey: $settingKey, '
        'settingValue: $settingValue, '
        'fromPage: $fromPage}';
  }
}
