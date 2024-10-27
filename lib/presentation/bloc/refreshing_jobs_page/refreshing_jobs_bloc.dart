import 'dart:developer';

import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_source_model.dart';
import 'package:convertouch/domain/use_cases/data_sources/get_data_source_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/start_refreshing_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, RefreshingJobsFetched> {
  final StartRefreshingJobUseCase startRefreshingJobUseCase;
  final StopJobUseCase stopJobUseCase;
  final GetDataSourceUseCase getDataSourceUseCase;
  final ConversionBloc conversionBloc;
  final NavigationBloc navigationBloc;

  RefreshingJobsBloc({
    required this.startRefreshingJobUseCase,
    required this.stopJobUseCase,
    required this.getDataSourceUseCase,
    required this.conversionBloc,
    required this.navigationBloc,
  }) : super(
          const RefreshingJobsFetched(
            jobs: {},
            currentDataSourceKeys: {},
          ),
        ) {
    on<FetchRefreshingJobs>(_onJobsFetch);
    on<FetchRefreshingJob>(_onJobFetch);
    on<StartRefreshingJobForConversion>(_onStartRefreshingJobForConversion);
    on<StopRefreshingJobForConversion>(_onStopRefreshingJobForConversion);
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(state);
  }

  _onJobFetch(
    FetchRefreshingJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    DataSourceModel currentDataSource = ObjectUtils.tryGet(
      await getDataSourceUseCase.execute(
        InputDataSourceModel(
          unitGroupName: event.unitGroupName,
          dataSourceKey: state.currentDataSourceKeys[event.unitGroupName],
        ),
      ),
    );

    emit(
      RefreshingJobsFetched(
        jobs: state.jobs,
        currentDataSourceKeys: state.currentDataSourceKeys,
        currentDataSourceUrl: currentDataSource.url,
        currentCompletedAt:
            state.jobs[event.unitGroupName]?.completedAt ?? 'Never',
      ),
    );
  }

  _onStartRefreshingJobForConversion(
    StartRefreshingJobForConversion event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, JobModel> activeJobs = Map.of(state.jobs);

    JobModel<InputDataSourceModel, NetworkDataModel> job = JobModel(
      params: InputDataSourceModel(
        unitGroupName: event.unitGroupName,
        dataSourceKey: state.currentDataSourceKeys[event.unitGroupName],
      ),
      onComplete: (networkData) async {
        log("onComplete start");
        if (networkData == null) {
          log("onComplete finish, network data = null");
          return;
        }

        if (networkData.dynamicCoefficients != null) {
          conversionBloc.add(
            UpdateConversionCoefficients(
              updatedUnitCoefs: networkData.dynamicCoefficients!,
            ),
          );
        }

        if (networkData.dynamicValue != null) {
          conversionBloc.add(
            EditConversionItemValue(
              newValue: null,
              newDefaultValue: networkData.dynamicValue!.value,
              unitId: networkData.dynamicValue!.unitId,
            ),
          );
        }

        log("onComplete finish");
      },
    );

    final startedJobResult = await startRefreshingJobUseCase.execute(job);

    if (startedJobResult.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: startedJobResult.left,
        ),
      );
    }
    if (startedJobResult.right.alreadyRunning) {
      navigationBloc.add(
        ShowException(
          exception: InternalException(
            message: "Job '${job.name}' is running at the moment",
            severity: ExceptionSeverity.info,
            stackTrace: null,
            dateTime: DateTime.now(),
          ),
        ),
      );
    } else {
      activeJobs.update(
        event.unitGroupName,
        (value) => startedJobResult.right,
      );
    }

    emit(
      RefreshingJobsFetched(
        jobs: activeJobs,
        currentDataSourceKeys: state.currentDataSourceKeys,
      ),
    );
  }

  _onStopRefreshingJobForConversion(
    StopRefreshingJobForConversion event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, JobModel> activeJobs = Map.of(state.jobs);

    final stoppedJobResult = await stopJobUseCase.execute(
      activeJobs[event.unitGroupName]!,
    );

    if (stoppedJobResult.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: stoppedJobResult.left,
        ),
      );
    } else {
      activeJobs.update(event.unitGroupName, (value) => stoppedJobResult.right);
    }

    emit(
      RefreshingJobsFetched(
        jobs: activeJobs,
        currentDataSourceKeys: state.currentDataSourceKeys,
      ),
    );
  }

  @override
  RefreshingJobsFetched? fromJson(Map<String, dynamic> json) {
    return RefreshingJobsFetched.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RefreshingJobsFetched state) {
    return state.toJson();
  }
}
