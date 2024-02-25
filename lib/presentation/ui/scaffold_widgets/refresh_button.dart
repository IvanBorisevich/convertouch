import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/progress_button.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  final bool determinate;

  const ConvertouchRefreshFloatingButton({
    this.determinate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ConvertouchColorScheme refreshButtonColor =
          refreshButtonColors[appState.theme]!;

      return conversionBlocBuilder((conversionState) {
        return refreshingJobsBlocBuilder((jobsState) {
          return ConvertouchProgressButton(
            visible: conversionState.showRefreshButton,
            determinate: determinate,
            buttonWidget: ConvertouchFloatingActionButton(
              onClick: () {
                BlocProvider.of<RefreshingJobsBloc>(context).add(
                  ExecuteJob(
                    unitGroupName: conversionState.conversion.unitGroup!.name,
                    conversionToBeRebuilt: conversionState.conversion,
                  ),
                );
              },
              icon: Icons.refresh_rounded,
              colorScheme: refreshButtonColor,
            ),
            radius: 28,
            onProgressIndicatorClick: () {
              BlocProvider.of<RefreshingJobsBloc>(context).add(
                StopJob(
                  unitGroupName: conversionState.conversion.unitGroup!.name,
                ),
              );
            },
            margin: const EdgeInsets.only(right: 7),
            progressStream: jobsState
                .jobs[conversionState.conversion.unitGroup?.name]
                ?.progressController
                ?.stream,
            progressIndicatorColor: refreshButtonColor.foreground.regular,
          );
        });
      });
    });
  }
}
