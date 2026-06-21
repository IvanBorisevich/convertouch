import 'dart:developer';

import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_stop_model.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/utils/job_utils.dart' as job_utils;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, RefreshingJobsFetched> {
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
    on<StartRefreshingJob>(_onStartRefreshingJob);
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
    DynamicDataType? dynamicDataType = dynamicDataGroups[event.unitGroupName];
    InputDynamicDataFetchModel? inputDynamicDataFetchModel;

    switch (dynamicDataType) {
      case DynamicDataType.coefficients:
        inputDynamicDataFetchModel = InputDynamicCoefficientsFetchModel(
          params: event.params,
        );
        break;
      case DynamicDataType.singleValue:
        if (event.srcUnit != null) {
          inputDynamicDataFetchModel = InputDynamicValueFetchModel(
            srcUnit: event.srcUnit!,
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

    JobModel job = JobModel(
      params: inputDynamicDataFetchModel,
      executionMode: event.jobExecutionMode,
      beforeStart: (controller) {
        add(
          ChangeJobInfo(
            jobPatch: JobModel(
              progressController: controller,
            ),
            unitGroupName: event.unitGroupName,
            paramSetName: event.params.paramSet.name,
          ),
        );
      },
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
    );

    final startedJobResult = await startJobUseCase.execute(job);

    if (startedJobResult.isLeft) {
      event.onError?.call(startedJobResult.left);
    }
  }

  _onStopRefreshingJob(
    StopRefreshingJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    var activeJobs = ObjectUtils.copyMap(state.jobs);

    JobModel? jobToStop =
        activeJobs[job_utils.jobKey(event.unitGroupName, event.paramSetName)];

    if (jobToStop == null) {
      return;
    }

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
      add(
        ChangeJobInfo(
          jobPatch: stoppedJobResult.right,
          unitGroupName: event.unitGroupName,
          paramSetName: event.paramSetName,
        ),
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
    var patchedJobsMap = job_utils.patchJobsMap(
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
    log("Serializing jobs json map: $json");
    return RefreshingJobsFetched.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RefreshingJobsFetched state) {
    return state.toJson();
  }

  @override
  Future<void> close() async {
    for (var job in state.jobs.values) {
      if (job.progressController != null && !job.progressController!.isClosed) {
        await job.progressController!.close();
      }
    }

    log("Job stream controllers have been closed");

    return super.close();
  }
}
