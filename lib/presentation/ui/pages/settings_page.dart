import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_event.dart';
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
              refreshingJobsBlocBuilder((jobState) {
                return ConvertouchSettingsGroup(
                  name: "Data Refreshing",
                  items: [
                    for (final item in jobState.items)
                      SettingItem.regular(
                        title: item.name,
                        theme: appState.theme,
                        onTap: () {
                          BlocProvider.of<RefreshingJobDetailsBloc>(context)
                              .add(
                            OpenJobDetails(
                              job: item,
                            ),
                          );
                          Navigator.of(context).pushNamed(
                            PageName.refreshingJobDetailsPage.name,
                          );
                        },
                      ),
                  ],
                  theme: appState.theme,
                );
              }),
            ],
          ),
        ),
        floatingActionButton: null,
      );
    });
  }
}