import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobDetailsPage extends StatelessWidget {
  const ConvertouchRefreshingJobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            // if (jobsState is RefreshingJobDetailsOpened) {
            //   return ConvertouchPage(
            //     title: jobsState.openedJob.name,
            //     customLeadingIcon: null,
            //     appBarRightWidgets: null,
            //     body: SingleChildScrollView(
            //       child: Column(
            //         children: [
            //           ConvertouchSettingsGroup(
            //             name: "Auto Refresh",
            //             items: [
            //               for (final value in Cron.values)
            //                 SettingItem<Cron>.radio(
            //                   value: value,
            //                   titleMapper: (value) => value.name,
            //                   selectedValue: jobsState.openedJob.selectedCron,
            //                   theme: appState.theme,
            //                   onChanged: (Cron? newValue) {
            //                     if (newValue != null) {
            //                       BlocProvider.of<RefreshingJobsBloc>(context).add(
            //                         ChangeRefreshingJobCron(
            //                           unitGroupName:
            //                               jobsState.openedJob.unitGroupName,
            //                           newCron: newValue,
            //                         ),
            //                       );
            //                     }
            //                   },
            //                 ),
            //             ],
            //             theme: appState.theme,
            //           ),
            //         ],
            //       ),
            //     ),
            //     floatingActionButton: null,
            //   );
            // } else {
            //   return empty();
            // }
            return const SizedBox(
              height: 0,
              width: 0,
            );
          },
        );
      },
    );
  }
}
