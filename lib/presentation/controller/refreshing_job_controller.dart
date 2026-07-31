import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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

  void createRefreshingJob(
    BuildContext context, {
    required String unitGroupName,
    required String? paramSetName,
    required JobExecutionMode jobExecutionMode,
  }) {
    if (paramSetName == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      CreateRefreshingJob(
        unitGroupName: unitGroupName,
        paramSetName: paramSetName,
        jobExecutionMode: jobExecutionMode,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void startRefreshingJob(
    BuildContext context, {
    required String unitGroupName,
    required ConversionParamSetValueModel? params,
    required UnitModel? srcUnit,
  }) {
    if (params == null) {
      return;
    }

    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StartRefreshingJob(
        unitGroupName: unitGroupName,
        params: params,
        srcUnitOfRefreshingValue: srcUnit,
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
