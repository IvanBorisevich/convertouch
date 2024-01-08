import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_progress_bloc.dart';
import 'package:convertouch/presentation/ui/items_view/refreshing_jobs_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshingJobsPage extends StatelessWidget {
  const ConvertouchRefreshingJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return refreshingJobsBlocBuilder((jobsState) {
        return BlocListener<RefreshingJobsProgressBloc, RefreshingJobsState>(
          listener: (_, state) {
            if (state is RefreshingJobsProgressUpdated &&
                state.completedJobId != null) {
              BlocProvider.of<RefreshingJobsBloc>(context).add(
                const FetchRefreshingJobs(),
              );
            }
          },
          child: refreshingJobsProgressBlocBuilder((jobsProgressState) {
            return ConvertouchPage(
              appState: appState,
              title: "Refresh Data",
              body: ConvertouchRefreshingJobsView(
                jobsState.items,
                progressValues: jobsProgressState.progressValues,
                onItemClick: (item) {
                  BlocProvider.of<RefreshingJobDetailsBloc>(context).add(
                    OpenJobDetails(
                      job: item,
                      progressValue: jobsProgressState.progressValues[item.id],
                    ),
                  );
                  Navigator.of(context).pushNamed(refreshingJobDetailsPage);
                },
                onDataRefreshStart: (item) {
                  BlocProvider.of<RefreshingJobsProgressBloc>(context).add(
                    StartDataRefreshing(
                      job: item,
                      progressValues: jobsProgressState.progressValues,
                    ),
                  );
                },
                onDataRefreshStop: (item) {
                  BlocProvider.of<RefreshingJobsProgressBloc>(context).add(
                    StopDataRefreshing(
                      job: item,
                      progressValues: jobsProgressState.progressValues,
                    ),
                  );
                },
                onDataRefreshComplete: (item) {
                  BlocProvider.of<RefreshingJobsProgressBloc>(context).add(
                    CompleteDataRefreshing(
                      job: item,
                      progressValues: jobsProgressState.progressValues,
                    ),
                  );
                },
                theme: appState.theme,
              ),
            );
          }),
        );
      });
    });
  }
}
