import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class GetAppSettings extends AppEvent {
  const GetAppSettings();

  @override
  String toString() {
    return 'GetAppSettings{}';
  }
}

class ChangeSetting<T> extends AppEvent {
  final String settingKey;
  final T settingValue;

  const ChangeSetting({
    required this.settingKey,
    required this.settingValue,
  });

  @override
  String toString() {
    return 'ChangeSetting{'
        'settingKey: $settingKey, '
        'settingValue: $settingValue}';
  }
}
