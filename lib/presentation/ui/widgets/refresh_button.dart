import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  final ConversionModel conversion;
  final bool determinate;
  final bool visible;
  final bool disabled;
  final void Function(JobResultModel)? onRefreshSuccess;

  const ConvertouchRefreshFloatingButton({
    required this.conversion,
    this.determinate = false,
    this.visible = true,
    this.disabled = false,
    this.onRefreshSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String unitGroupName = conversion.unitGroup.name;
    ConversionParamSetValueModel? params = conversion.params?.active;

    return appBlocBuilder(
      builderFunc: (appState) {
        WidgetColorScheme refreshButtonColor =
            appColors[appState.theme].refreshFloatingButton;

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            return ConvertouchProgressButton(
              visible: visible,
              determinate: determinate,
              radius: 28,
              margin: const EdgeInsets.only(right: 7),
              colors: refreshButtonColor,
              buttonWidget: ConvertouchFloatingActionButton.refresh(
                disabled: disabled,
                onClick: () {
                  refreshingJobController.startRefresh(
                    context,
                    groupName: unitGroupName,
                    params: params,
                    srcUnit: conversion.srcUnitValue?.unit,
                    jobExecutionMode:
                        JobExecutionMode.continueAlreadyRunningJobIfAny,
                  );
                },
                colorScheme: refreshButtonColor,
              ),
              onSuccess: onRefreshSuccess,
              notificationFunc: (info) {
                navigationController.showException(context, exception: info);
              },
              onProgressIndicatorClick: () {
                // refreshingJobController.stopRefresh(
                //   context,
                //   groupName: unitGroupName,
                //   paramSetName: params?.paramSet.name,
                // );
              },
              progressStream: jobsState
                  .jobs[unitGroupName]?[params?.paramSet.name]
                  ?.progressController
                  ?.stream,
            );
          },
        );
      },
    );
  }
}
