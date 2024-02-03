import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class RestoreAppSettings extends AppEvent {
  const RestoreAppSettings();

  @override
  String toString() {
    return 'RestoreAppSettings{}';
  }
}

class SaveSetting<T> extends AppEvent {
  final String settingKey;
  final T settingValue;

  const SaveSetting({
    required this.settingKey,
    required this.settingValue,
  });

  @override
  String toString() {
    return 'SaveSetting{'
        'settingKey: $settingKey, '
        'settingValue: $settingValue}';
  }
}
