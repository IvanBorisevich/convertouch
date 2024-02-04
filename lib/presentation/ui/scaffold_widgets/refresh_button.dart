import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/progress_button.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  const ConvertouchRefreshFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      BaseColorSet refreshButtonColor =
          refreshButtonColors[appState.theme]!.regular;

      return conversionBlocBuilder((conversionState) {
        return refreshingJobsControlBlocBuilder((jobsControlState) {
          final jobInProgress =
              jobsControlState.jobsInProgress[conversionState.job?.id];

          return ConvertouchProgressButton(
            buttonWidget: ConvertouchFloatingActionButton(
              visible: conversionState.showRefreshButton,
              onClick: () {
                BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                  ExecuteJob(
                    job: conversionState.job!,
                    jobsInProgress: jobsControlState.jobsInProgress,
                    conversionToBeRebuilt: conversionState.conversion,
                  ),
                );
              },
              icon: Icons.refresh_rounded,
              colorSet: refreshButtonColor,
            ),
            radius: 28,
            onProgressIndicatorClick: () {
              BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                StopJob(
                  job: conversionState.job!,
                  jobsInProgress: jobsControlState.jobsInProgress,
                ),
              );
            },
            onOngoingProgressIndicatorClick: () {
              BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                StopJob(
                  job: conversionState.job!,
                  jobsInProgress: jobsControlState.jobsInProgress,
                ),
              );
            },
            margin: const EdgeInsets.only(right: 7),
            progressStream: jobInProgress?.progressController?.stream,
            progressIndicatorColor: refreshButtonColor.foreground,
          );
        });
      });
    });
  }
}
