import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/controller/refresh_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final refreshingJobController = di.locator.get<RefreshingJobController>();

class RefreshingJobController {
  const RefreshingJobController();

  void getJobs(BuildContext context, {required UnitGroupModel unitGroup}) {
    if (unitGroup.refreshable) {
      BlocProvider.of<RefreshingJobsBloc>(context).add(
        const FetchRefreshingJobs(),
      );
    }
  }

  void startRefreshingJob(
    BuildContext context, {
    required String unitGroupName,
    required ConversionParamSetValueModel? params,
    required UnitModel? srcUnit,
    required JobExecutionMode jobExecutionMode,
  }) {
    if (params == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StartRefreshingJob(
        unitGroupName: unitGroupName,
        params: params,
        srcUnitOfRefreshingValue: srcUnit,
        jobExecutionMode: jobExecutionMode,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void stopRefreshingJob(
    BuildContext context, {
    required String unitGroupName,
    required String? paramSetName,
    bool stopOnError = false,
    bool forceStop = false,
    void Function()? onComplete,
  }) {
    if (paramSetName == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StopRefreshingJob(
        unitGroupName: unitGroupName,
        paramSetName: paramSetName,
        stopOnError: stopOnError,
        forceStop: forceStop,
        onComplete: onComplete,
      ),
    );
  }
}

ParamSetValueChangedCallback startRefreshByParams(
  BuildContext context, {
  bool autoRefresh = false,
}) {
  return (conversion) {
    refreshButtonController.changeState(
      context,
      unitGroupId: conversion.unitGroup.id,
      visible: conversion.unitGroup.refreshable,
      disabled: false,
    );

    if (autoRefresh) {
      refreshingJobController.startRefreshingJob(
        context,
        unitGroupName: conversion.unitGroup.name,
        params: conversion.params?.active,
        srcUnit: conversion.srcUnitValue?.unit,
        jobExecutionMode: JobExecutionMode.startNewJob,
      );
    }
  };
}
