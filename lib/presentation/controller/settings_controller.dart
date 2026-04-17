import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final settingsController = di.locator.get<SettingsController>();

class SettingsController {
  const SettingsController();

  void changeSetting(
    BuildContext context, {
    required SettingKey key,
    required dynamic newValue,
    PageName? fromPage,
  }) {
    BlocProvider.of<AppBloc>(context).add(
      ChangeSetting(
        settingKey: key,
        settingValue: newValue,
        fromPage: fromPage,
      ),
    );
  }
}
