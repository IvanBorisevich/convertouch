import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/setting_item.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/settings_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSettingsPage extends StatelessWidget {
  const ConvertouchSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return ConvertouchPage(
        title: "Settings",
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ConvertouchSettingsGroup(
              //   name: "Data Sources",
              //   items: [
              //     for (JobDataSourceModel value
              //     in pageState.job.dataSources)
              //       SettingItem<JobDataSourceModel>.radio(
              //         value: value,
              //         titleMapper: (value) => value.name,
              //         selectedValue: pageState.job.selectedDataSource,
              //         theme: appState.theme,
              //         onChanged: (JobDataSourceModel? newValue) {
              //           if (newValue != null) {
              //             BlocProvider.of<RefreshingJobDetailsBloc>(context)
              //                 .add(
              //               SelectDataSource(
              //                 newDataSource: newValue,
              //                 job: pageState.job,
              //               ),
              //             );
              //           }
              //         },
              //       ),
              //   ],
              //   theme: appState.theme,
              // ),
              // ConvertouchSettingsGroup(
              //   name: "Auto Refresh",
              //   items: [
              //     for (int i = 0; i < Cron.values.length; i++)
              //       SettingItem<Cron>.radio(
              //         value: Cron.values[i],
              //         titleMapper: (value) => value.name,
              //         selectedValue: pageState.job.cron,
              //         theme: appState.theme,
              //         onChanged: (Cron? newValue) {
              //           if (newValue != null) {
              //             BlocProvider.of<RefreshingJobDetailsBloc>(context)
              //                 .add(
              //               SelectAutoRefreshCron(
              //                 newCron: newValue,
              //                 job: pageState.job,
              //               ),
              //             );
              //           }
              //         },
              //       ),
              //   ],
              //   theme: appState.theme,
              // ),
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
                              settingKey: SettingKeys.theme,
                              settingValue: newValue.value,
                            ),
                          );
                        }
                      },
                    ),
                ],
                theme: appState.theme,
              ),
            ],
          ),
        ),
        floatingActionButton: null,
      );
    });
  }
}
