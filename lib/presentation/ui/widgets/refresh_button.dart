import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
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
  final void Function(JobResultModel)? onFetchSuccess;
  final void Function(ConvertouchException)? onFetchError;

  const ConvertouchRefreshFloatingButton({
    required this.conversion,
    this.determinate = false,
    this.visible = true,
    this.disabled = false,
    this.onFetchSuccess,
    this.onFetchError,
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
                  refreshingJobController.startRefreshingJob(
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
              onFetchSuccess: (jobResult) {
                onFetchSuccess?.call(jobResult);

                refreshingJobController.stopRefreshingJob(
                  context,
                  groupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: jobResult.notification!,
                    );
                  },
                );
              },
              onFetchError: (exception) {
                onFetchError?.call(exception);

                refreshingJobController.stopRefreshingJob(
                  context,
                  groupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  stopOnError: true,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: exception,
                    );
                  },
                );
              },
              onProgressIndicatorClick: () {
                refreshingJobController.stopRefreshingJob(
                  context,
                  groupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  forceStop: true,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: ConvertouchException(
                        message: "Refreshing stopped",
                        severity: ExceptionSeverity.info,
                        stackTrace: null,
                        dateTime: DateTime.now(),
                      ),
                    );
                  },
                );
              },
              progressStream: jobsState
                  .getJob(unitGroupName, params?.paramSet.name)
                  ?.progressController
                  ?.stream,
            );
          },
        );
      },
    );
  }
}
