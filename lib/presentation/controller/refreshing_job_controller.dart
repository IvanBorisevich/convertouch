import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
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
    required ConversionModel conversion,
    required JobExecutionMode jobExecutionMode,
  }) {
    if (conversion.params == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StartRefreshingJob(
        unitGroupName: conversion.unitGroup.name,
        params: conversion.params!.active!,
        srcUnit: conversion.srcUnitValue?.unit,
        jobExecutionMode: jobExecutionMode,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void stopRefreshingJob(
    BuildContext context, {
    required ConversionModel conversion,
    bool stopOnError = false,
    bool forceStop = false,
    void Function()? onComplete,
  }) {
    String? paramSetName = conversion.params?.active?.paramSet.name;

    if (paramSetName == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StopRefreshingJob(
        unitGroupName: conversion.unitGroup.name,
        paramSetName: paramSetName,
        stopOnError: stopOnError,
        forceStop: forceStop,
        onComplete: onComplete,
      ),
    );
  }
}
