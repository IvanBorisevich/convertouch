import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/refreshing_jobs_view.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshingJobsPage extends StatelessWidget {
  const ConvertouchRefreshingJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ScaffoldColorVariation scaffoldColor =
          scaffoldColors[appState.theme]!.regular;

      return refreshingJobsBlocBuilder((jobsState) {
        return BlocListener<RefreshingJobsControlBloc,
            RefreshingJobsControlState>(
          listener: (_, state) {
            if (state is RefreshingJobsProgressUpdated &&
                state.completedJobId != null) {
              BlocProvider.of<RefreshingJobsBloc>(context).add(
                const FetchRefreshingJobs(),
              );
            } else if (state is RefreshingJobsControlNotificationState) {
              showSnackBar(
                context,
                message: state.message,
                contentColor: scaffoldColor.backgroundColor,
              );
            }
          },
          child: refreshingJobsControlBlocBuilder((jobsProgressState) {
            return ConvertouchPage(
              title: "Refresh Data",
              body: ConvertouchRefreshingJobsView(
                jobsState.items,
                jobsInProgress: jobsProgressState.jobsInProgress,
                onItemClick: (item) {
                  BlocProvider.of<RefreshingJobDetailsBloc>(context).add(
                    OpenJobDetails(
                      job: item,
                    ),
                  );
                  Navigator.of(context).pushNamed(
                    PageName.refreshingJobDetailsPage.name,
                  );
                },
                onJobStartClick: (item) {
                  BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                    ExecuteJob(
                      job: item,
                      jobsInProgress: jobsProgressState.jobsInProgress,
                    ),
                  );
                },
                onJobStopClick: (item) {
                  BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                    StopJob(
                      job: item,
                      jobsInProgress: jobsProgressState.jobsInProgress,
                    ),
                  );
                },
                onJobFinish: (item, jobResult) {
                  // BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                  //   FinishJob(
                  //     job: item,
                  //     jobsInProgress: jobsProgressState.jobsInProgress,
                  //   ),
                  // );
                  // if (jobResult.refreshedConversionParams != null) {
                  //   log("Rebuild conversion (on jobs page)");
                  //   BlocProvider.of<ConversionBloc>(context).add(
                  //     BuildConversion(
                  //       conversionParams: jobResult.refreshedConversionParams!,
                  //     ),
                  //   );
                  // }
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
