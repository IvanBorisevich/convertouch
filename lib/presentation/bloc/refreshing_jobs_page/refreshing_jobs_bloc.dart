import 'dart:developer';

import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_refresh_model.dart';
import 'package:convertouch/domain/use_cases/jobs/start_refreshing_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, RefreshingJobsFetched> {
  final StartRefreshingJobUseCase startRefreshingJobUseCase;
  final StopJobUseCase stopJobUseCase;

  RefreshingJobsBloc({
    required this.startRefreshingJobUseCase,
    required this.stopJobUseCase,
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
    JobsMap activeJobs = ObjectUtils.copyMap(state.jobs);

    JobModel<InputDataRefreshModel, DynamicDataModel> job = JobModel(
      params: InputDataRefreshModel(
        unitGroupName: event.unitGroupName,
        params: event.params,
      ),
      onSuccess: (networkData) {
        log("onComplete start");

        event.onFetchSuccess?.call(networkData);

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

        event.onSuccess?.call(
          info: ConvertouchException(
            message: "Refreshed successfully!",
            severity: ExceptionSeverity.info,
            stackTrace: null,
            dateTime: DateTime.now(),
          ),
        );

        log("onComplete finish");
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

        event.onError?.call(exception);
      },
    );

    final startedJobResult = await startRefreshingJobUseCase.execute(job);

    if (startedJobResult.isLeft) {
      event.onError?.call(startedJobResult.left);
    } else if (startedJobResult.right.alreadyRunning) {
      event.onSuccess?.call(
        info: InternalException(
          message: "Job '${job.name}' is running at the moment",
          severity: ExceptionSeverity.info,
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    } else {
      log("Update active jobs info");

      _updateJobMap(
        activeJobs,
        unitGroupName: event.unitGroupName,
        paramSetName: event.params.paramSet.name,
        modifiedJob: startedJobResult.right,
      );
    }

    emit(state.copyWith(jobs: activeJobs));
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
      _updateJobMap(
        activeJobs,
        unitGroupName: event.unitGroupName,
        paramSetName: event.paramSetName,
        modifiedJob: stoppedJobResult.right,
      );
    }

    emit(state.copyWith(jobs: activeJobs));
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
          alreadyRunning: Patchable(jobPatch.alreadyRunning),
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
}
