import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
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

  void startRefresh(
    BuildContext context, {
    required String groupName,
    required ConversionParamSetValueModel params,
    void Function(DynamicDataModel)? onFetchSuccess,
  }) {
    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StartRefreshingJobForConversion(
        unitGroupName: groupName,
        params: params,
        onFetchSuccess: onFetchSuccess,
        onSuccess: ({info}) {
          if (info != null) {
            navigationController.showException(context, exception: info);
          }
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void stopRefresh(
    BuildContext context, {
    required String groupName,
    required String paramSetName,
  }) {
    BlocProvider.of<RefreshingJobsBloc>(context).add(
      StopRefreshingJobForConversion(
        unitGroupName: groupName,
        paramSetName: paramSetName,
      ),
    );
  }
}
