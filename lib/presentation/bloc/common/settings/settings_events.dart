import 'package:convertouch/domain/model/setting_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class SettingsEvent extends ConvertouchEvent {
  const SettingsEvent();
}

class SaveSetting extends SettingsEvent {
  final SettingItemModel settingItem;

  const SaveSetting({
    required this.settingItem,
  });

  @override
  String toString() {
    return 'SaveSetting{settingItem: $settingItem}';
  }
}