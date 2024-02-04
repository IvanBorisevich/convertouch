import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/setting_item.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/settings_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshingJobDetailsPage extends StatelessWidget {
  const ConvertouchRefreshingJobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return refreshingJobsControlBlocBuilder((jobsProgressState) {
        return refreshingJobDetailsBlocBuilder((jobDetailsState) {
          // RefreshingJobModel? jobInProgress =
          //     jobsProgressState.jobsInProgress[jobDetailsState.job.id];

          return BlocListener<RefreshingJobDetailsBloc,
              RefreshingJobDetailsState>(
            listener: (_, state) {
              if (state is RefreshingJobDetailsReady && state.updated) {
                BlocProvider.of<RefreshingJobsBloc>(context).add(
                  const FetchRefreshingJobs(),
                );
              }
            },
            child: ConvertouchPage(
              title: jobDetailsState.job.name,
              customLeadingIcon: null,
              appBarRightWidgets: null,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ConvertouchSettingsGroup(
                      name: "Auto Refresh",
                      items: [
                        for (final value in Cron.values)
                          SettingItem<Cron>.radio(
                            value: value,
                            titleMapper: (value) => value.name,
                            selectedValue: jobDetailsState.job.cron,
                            theme: appState.theme,
                            onChanged: (Cron? newValue) {
                              if (newValue != null) {
                                BlocProvider.of<RefreshingJobDetailsBloc>(
                                        context)
                                    .add(
                                  SelectJobCron(
                                    newCron: newValue,
                                    job: jobDetailsState.job,
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
            ),
          );
        });
      });
    });
  }
}
