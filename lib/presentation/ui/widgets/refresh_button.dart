import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  final String unitGroupName;
  final ConversionParamSetValueModel params;
  final bool determinate;
  final bool visible;

  const ConvertouchRefreshFloatingButton({
    required this.unitGroupName,
    required this.params,
    this.determinate = false,
    this.visible = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        WidgetColorScheme refreshButtonColor =
            appColors[appState.theme].refreshFloatingButton;

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            return ConvertouchProgressButton(
              visible: visible,
              determinate: determinate,
              buttonWidget: ConvertouchFloatingActionButton.refresh(
                onClick: () {
                  refreshingJobController.startRefresh(
                    context,
                    groupName: unitGroupName,
                    params: params,
                    onFetchSuccess: (data) {
                      conversionController.updateFromNetwork(
                        context,
                        data: data,
                      );
                    },
                  );
                },
                colorScheme: refreshButtonColor,
              ),
              radius: 28,
              onProgressIndicatorClick: () {
                refreshingJobController.stopRefresh(
                  context,
                  groupName: unitGroupName,
                  paramSetName: params.paramSet.name,
                );
              },
              margin: const EdgeInsets.only(right: 7),
              progressStream: jobsState
                  .jobs[unitGroupName]?[params.paramSet.name]
                  ?.progressController
                  ?.stream,
              colorsInProgress: refreshButtonColor,
            );
          },
        );
      },
    );
  }
}
