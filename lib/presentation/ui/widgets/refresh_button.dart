import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  final String unitGroupName;
  final bool determinate;
  final bool visible;

  const ConvertouchRefreshFloatingButton({
    required this.unitGroupName,
    this.determinate = false,
    this.visible = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final jobsBloc = BlocProvider.of<RefreshingJobsBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        ConvertouchColorScheme refreshButtonColor =
            refreshButtonColors[appState.theme]!;

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            return ConvertouchProgressButton(
              visible: visible,
              determinate: determinate,
              buttonWidget: ConvertouchFloatingActionButton.refresh(
                onClick: () {
                  jobsBloc.add(
                    StartRefreshingJobForConversion(
                      unitGroupName: unitGroupName,
                    ),
                  );
                },
                colorScheme: refreshButtonColor,
              ),
              radius: 28,
              onProgressIndicatorClick: () {
                jobsBloc.add(
                  StopRefreshingJobForConversion(
                    unitGroupName: unitGroupName,
                  ),
                );
              },
              margin: const EdgeInsets.only(right: 7),
              progressStream:
                  jobsState.jobs[unitGroupName]?.progressController?.stream,
              progressIndicatorColor: refreshButtonColor.foreground.selected,
            );
          },
        );
      },
    );
  }
}
