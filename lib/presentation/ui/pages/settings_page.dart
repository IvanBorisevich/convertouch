import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/setting_item.dart';
import 'package:convertouch/presentation/ui/widgets/settings_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSettingsPage extends StatelessWidget {
  const ConvertouchSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        return ConvertouchPage(
          title: "Settings",
          body: SingleChildScrollView(
            child: Column(
              children: [
                ConvertouchSettingsGroup(
                  name: "UI Theme",
                  items: [
                    for (final value in ConvertouchUITheme.values)
                      SettingItem<ConvertouchUITheme>.radio(
                        value: value,
                        titleMapper: (value) => value.value,
                        selectedValue: appState.theme,
                        theme: appState.theme,
                        onChanged: (ConvertouchUITheme? newValue) {
                          if (newValue != null) {
                            BlocProvider.of<AppBloc>(context).add(
                              ChangeSetting(
                                settingKey: SettingKey.theme.name,
                                settingValue: newValue.value,
                              ),
                            );
                          }
                        },
                      ),
                  ],
                  theme: appState.theme,
                ),
                // refreshingJobsBlocBuilder((jobState) {
                //   return ConvertouchSettingsGroup(
                //     name: "Data Refreshing",
                //     items: [
                //       for (final item in jobState.jobs.values)
                //         SettingItem.regular(
                //           title: item.name,
                //           theme: appState.theme,
                //           onTap: () {
                //             BlocProvider.of<RefreshingJobsBloc>(context).add(
                //               OpenJobDetails(
                //                 unitGroupName: item.unitGroupName,
                //               ),
                //             );
                //           },
                //         ),
                //     ],
                //     theme: appState.theme,
                //   );
                // }),
                ConvertouchSettingsGroup(
                  name: "About",
                  onHeaderTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: appName,
                      applicationVersion: "Version: ${appState.appVersion}",
                      applicationLegalese: "©2025, Made by johnbor7",
                    );
                  },
                  theme: appState.theme,
                ),
              ],
            ),
          ),
          floatingActionButton: null,
        );
      },
    );
  }
}
