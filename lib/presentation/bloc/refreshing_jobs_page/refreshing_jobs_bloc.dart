import 'dart:developer';

import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
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
    on<StartRefreshingJobForConversion>(_onStartRefreshingJobForConversion);
    on<StopRefreshingJobForConversion>(_onStopRefreshingJobForConversion);
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
    await _patchJobAndEmit(
      activeJobs: ObjectUtils.copyMap(state.jobs),
      unitGroupName: event.unitGroupName,
      paramSetName: event.paramSetName,
      jobPatch: event.jobPatch,
      emit: emit,
    );
  }

  _onStartRefreshingJobForConversion(
    StartRefreshingJobForConversion event,
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
      onStart: (controller) {
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
      onSuccess: (networkData) {
        add(
          ChangeJobInfo(
            jobPatch: JobModel(
              progressController: null,
              completedAt: DateTime.now(),
            ),
            unitGroupName: event.unitGroupName,
            paramSetName: event.params.paramSet.name,
          ),
        );
      },
      onError: (exception) {
        add(
          ChangeJobInfo(
            jobPatch: const JobModel(
              progressController: null,
            ),
            unitGroupName: event.unitGroupName,
            paramSetName: event.params.paramSet.name,
          ),
        );
      },
    );

    final startedJobResult = await startJobUseCase.execute(job);

    if (startedJobResult.isLeft) {
      event.onError?.call(startedJobResult.left);
    }
  }

  _onStopRefreshingJobForConversion(
    StopRefreshingJobForConversion event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    JobsMap activeJobs = ObjectUtils.copyMap(state.jobs);

    JobModel? jobToStop = activeJobs[event.unitGroupName]?[event.paramSetName];

    if (jobToStop == null) {
      return;
    }

    final stoppedJobResult = await stopJobUseCase.execute(jobToStop);

    if (stoppedJobResult.isLeft) {
      event.onError?.call(stoppedJobResult.left);
    } else {
      add(
        ChangeJobInfo(
          jobPatch: const JobModel(
            progressController: null,
          ),
          unitGroupName: event.unitGroupName,
          paramSetName: event.paramSetName,
        ),
      );
    }
  }

  _patchJobAndEmit({
    required JobsMap activeJobs,
    required String unitGroupName,
    required String paramSetName,
    required JobModel jobPatch,
    required Emitter<RefreshingJobsState> emit,
  }) async {
    var jobToPatch = activeJobs[unitGroupName]?[paramSetName];

    if (jobToPatch != null) {
      _updateJobMap(
        activeJobs,
        unitGroupName: unitGroupName,
        paramSetName: paramSetName,
        modifiedJob: jobToPatch.copyWith(
          params: Patchable(jobPatch.params),
          completedAt: Patchable(jobPatch.completedAt),
          selectedCron: Patchable(jobPatch.selectedCron),
          progressController: Patchable(
            jobPatch.progressController,
            patchNull: true,
          ),
        ),
      );
    }

    emit(state.copyWith(jobs: activeJobs));
  }

  void _updateJobMap(
    JobsMap activeJobs, {
    required String unitGroupName,
    required String paramSetName,
    required JobModel modifiedJob,
  }) {
    activeJobs.update(
      unitGroupName,
      (groupJobs) => groupJobs
        ..update(
          paramSetName,
          (job) => modifiedJob,
          ifAbsent: () => modifiedJob,
        ),
      ifAbsent: () => {
        paramSetName: modifiedJob,
      },
    );
  }

  @override
  RefreshingJobsFetched? fromJson(Map<String, dynamic> json) {
    log("Serialized refreshing job json map: $json");
    return RefreshingJobsFetched.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RefreshingJobsFetched state) {
    return state.toJson();
  }

  @override
  Future<void> close() async {
    for (var unitGroupJobs in state.jobs.values) {
      for (var job in unitGroupJobs.values) {
        await job.progressController?.close();
      }
    }

    log("Job stream controllers have been closed");

    return super.close();
  }
}
