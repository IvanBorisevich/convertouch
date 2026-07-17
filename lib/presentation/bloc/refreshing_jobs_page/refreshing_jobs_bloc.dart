import 'dart:async';
import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_start_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_stop_model.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/utils/job_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, RefreshingJobsFetched> {
  final JobsOperationsMap _jobOperations = {};

  final StartJobUseCase startJobUseCase;
  final StopJobUseCase stopJobUseCase;
  final FetchDynamicCoefficientsUseCase fetchDynamicCoefficientsUseCase;
  final FetchDynamicValueUseCase fetchDynamicValueUseCase;

  RefreshingJobsBloc({
    required this.startJobUseCase,
    required this.stopJobUseCase,
    required this.fetchDynamicCoefficientsUseCase,
    required this.fetchDynamicValueUseCase,
  }) : super(const RefreshingJobsFetched(jobs: {})) {
    on<FetchRefreshingJobs>(_onJobsFetch);
    on<ChangeJobInfo>(_onChangeJobInfo);
    on<StartRefreshingJob>(
      _onStartRefreshingJob,
      transformer: restartable(),
    );
    on<StopRefreshingJob>(_onStopRefreshingJob);
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(state);
  }

  _onChangeJobInfo(
    ChangeJobInfo event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    await _patchJobsMapAndEmit(
      unitGroupName: event.unitGroupName,
      paramSetName: event.paramSetName,
      jobPatch: event.jobPatch,
      emit: emit,
    );
  }

  _onStartRefreshingJob(
    StartRefreshingJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    var activeJobs = ObjectUtils.copyMap(state.jobs);

    JobModel? existingJob = findJob(
      activeJobs,
      unitGroupName: event.unitGroupName,
      paramSetName: event.params.paramSet.name,
    );

    if (existingJob != null &&
        existingJob.progressController != null &&
        !existingJob.progressController!.isClosed) {
      if (event.jobExecutionMode ==
          JobExecutionMode.continueAlreadyRunningJobIfAny) {
        event.onError?.call(
          ConvertouchException(
            message: "Job '${existingJob.name}' is running at the moment",
            severity: ExceptionSeverity.info,
          ),
        );

        return;
      } else {
        await cancelJobOperation(
          _jobOperations,
          unitGroupName: event.unitGroupName,
          paramSetName: event.params.paramSet.name,
        );

        final result = await stopJobUseCase.execute(
          InputJobStopModel(
            job: existingJob,
            forceStop: true,
            stopOnError: false,
          ),
        );

        if (result.isLeft) {
          event.onError?.call(result.left);
        }
      }
    }

    DynamicDataType? dynamicDataType = dynamicDataGroups[event.unitGroupName];
    InputDynamicDataFetchModel? inputDynamicDataFetchModel;

    switch (dynamicDataType) {
      case DynamicDataType.coefficients:
        inputDynamicDataFetchModel = InputDynamicCoefficientsFetchModel(
          groupName: event.unitGroupName,
          params: event.params,
        );
        break;
      case DynamicDataType.singleValue:
        if (event.srcUnitOfRefreshingValue != null) {
          inputDynamicDataFetchModel = InputDynamicValueFetchModel(
            groupName: event.unitGroupName,
            srcUnit: event.srcUnitOfRefreshingValue!,
            params: event.params,
          );
        }
        break;
      default:
        break;
    }

    if (inputDynamicDataFetchModel == null) {
      return;
    }

    final jobStreamController = StreamController<JobResultModel>.broadcast();

    JobModel job = JobModel(
      params: inputDynamicDataFetchModel,
      executionMode: event.jobExecutionMode,
      progressController: jobStreamController,
    );

    await _patchJobsMapAndEmit(
      unitGroupName: event.unitGroupName,
      paramSetName: event.params.paramSet.name,
      jobPatch: job,
      emit: emit,
    );

    final jobStartResult = await startJobUseCase.execute(
      InputJobStartModel(
        job: job,
        onExecute: (jobParams) async {
          if (jobParams == null) {
            return null;
          }

          if (jobParams is InputDynamicCoefficientsFetchModel) {
            return ObjectUtils.tryGet(
              await fetchDynamicCoefficientsUseCase.execute(jobParams),
            );
          }

          if (jobParams is InputDynamicValueFetchModel) {
            return ObjectUtils.tryGet(
              await fetchDynamicValueUseCase.execute(jobParams),
            );
          }

          return null;
        },
      ),
    );

    if (jobStartResult.isLeft) {
      event.onError?.call(jobStartResult.left);
    } else {
      patchJobsOperations(
        _jobOperations,
        unitGroupName: event.unitGroupName,
        paramSetName: event.params.paramSet.name,
        jobOperation: jobStartResult.right,
      );
    }
  }

  _onStopRefreshingJob(
    StopRefreshingJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    var activeJobs = ObjectUtils.copyMap(state.jobs);

    JobModel? jobToStop = findJob(
      activeJobs,
      unitGroupName: event.unitGroupName,
      paramSetName: event.paramSetName,
    );

    if (jobToStop == null) {
      return;
    }

    await cancelJobOperation(
      _jobOperations,
      unitGroupName: event.unitGroupName,
      paramSetName: event.paramSetName,
    );

    final stoppedJobResult = await stopJobUseCase.execute(
      InputJobStopModel(
        job: jobToStop,
        stopOnError: event.stopOnError,
        forceStop: event.forceStop,
      ),
    );

    if (stoppedJobResult.isLeft) {
      event.onError?.call(stoppedJobResult.left);
    } else {
      await _patchJobsMapAndEmit(
        unitGroupName: event.unitGroupName,
        paramSetName: event.paramSetName,
        jobPatch: stoppedJobResult.right,
        emit: emit,
      );

      event.onComplete?.call();
    }
  }

  _patchJobsMapAndEmit({
    required String unitGroupName,
    required String paramSetName,
    required JobModel jobPatch,
    required Emitter<RefreshingJobsState> emit,
  }) async {
    var patchedJobsMap = patchJobsMap(
      state.jobs,
      unitGroupName: unitGroupName,
      paramSetName: paramSetName,
      jobPatch: jobPatch,
    );

    emit(
      state.copyWith(jobs: patchedJobsMap),
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

  @override
  Future<void> close() async {
    await cancelAllJobOperations(_jobOperations);

    for (var job in state.jobs.values) {
      if (job.progressController != null && !job.progressController!.isClosed) {
        await job.progressController!.close();
      }
    }

    log("All ongoing jobs have been stopped");

    return super.close();
  }
}
