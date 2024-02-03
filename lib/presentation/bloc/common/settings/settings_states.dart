import 'package:convertouch/domain/model/setting_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class SettingsState extends ConvertouchState {
  const SettingsState();
}

class SettingsReady extends SettingsState {
  final Map<String, SettingItemModel> settings;

  const SettingsReady({
    required this.settings,
  });

  @override
  String toString() {
    return 'SettingsReady{settings: $settings}';
  }
}