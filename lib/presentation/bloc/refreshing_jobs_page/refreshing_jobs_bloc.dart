import 'dart:developer';

import 'package:convertouch/domain/constants/refreshing_jobs.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/execute_job_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc extends ConvertouchPersistentBloc<RefreshingJobsEvent,
    RefreshingJobsState> {
  final ExecuteJobUseCase executeJobUseCase;

  RefreshingJobsBloc({
    required this.executeJobUseCase,
  }) : super(const RefreshingJobsFetched(jobs: {})) {
    on<FetchRefreshingJobs>(_onJobsFetch);
    on<OpenJobDetails>(_onJobDetailsOpen);
    on<ChangeJobCron>(_onJobCronChange);
    on<ExecuteJob>(_onJobExecute);
    on<StopJob>(_onJobStop);
    on<FinishJob>(_onJobFinish);
  }

  Future<Map<String, RefreshingJobModel>> _getAllJobs() async {
    Map<String, RefreshingJobModel> refreshingJobs = {};

    if (state is RefreshingJobsFetched) {
      refreshingJobs = (state as RefreshingJobsFetched).jobs;
    }

    return refreshingJobs;
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    if (refreshingJobs.isEmpty) {
      refreshingJobs = refreshingJobsMap.map(
          (key, value) => MapEntry(key, RefreshingJobModel.fromJson(value)!));
    }

    emit(
      RefreshingJobsFetched(jobs: refreshingJobs),
    );
  }

  _onJobDetailsOpen(
    OpenJobDetails event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    emit(
      RefreshingJobDetailsOpened(
        jobs: refreshingJobs,
        openedJob: refreshingJobs[event.unitGroupName]!,
      ),
    );
  }

  _onJobCronChange(
    ChangeJobCron event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    RefreshingJobModel openedJob = refreshingJobs[event.unitGroupName]!;

    RefreshingJobModel updatedJob = RefreshingJobModel.coalesce(
      openedJob,
      cron: event.newCron,
    );

    refreshingJobs.update(event.unitGroupName, (value) => updatedJob);

    emit(
      RefreshingJobDetailsOpened(
        jobs: refreshingJobs,
        openedJob: updatedJob,
      ),
    );
  }

  _onJobExecute(
    ExecuteJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    RefreshingJobModel job = refreshingJobs[event.unitGroupName]!;

    if (job.progressController != null) {
      emit(
        RefreshingJobsNotificationState(
          message: "Job '${job.name}' is running at the moment",
        ),
      );
      emit(
        RefreshingJobsFetched(
          jobs: refreshingJobs,
        ),
      );
      return;
    }

    final startedJobResult = await executeJobUseCase.execute(
      InputExecuteJobModel(
        job: job,
        conversionToBeRebuilt: event.conversionToBeRebuilt,
        onJobComplete: (rebuiltConversion) {
          log("onJobComplete callback func");
          add(
            FinishJob(
              unitGroupName: event.unitGroupName,
              rebuiltConversion: rebuiltConversion,
            ),
          );
        },
      ),
    );

    if (startedJobResult.isLeft) {
      ConvertouchException exception = startedJobResult.left;
      if (exception.severity == ExceptionSeverity.error) {
        emit(
          RefreshingJobsErrorState(
            exception: exception,
            lastSuccessfulState: state,
          ),
        );
      } else {
        emit(
          RefreshingJobsNotificationState(
            message: exception.message,
          ),
        );
        emit(
          RefreshingJobsFetched(
            jobs: refreshingJobs,
          ),
        );
      }
    } else {
      refreshingJobs.update(
        event.unitGroupName,
        (value) => startedJobResult.right,
      );

      emit(
        RefreshingJobsFetched(
          jobs: refreshingJobs,
        ),
      );
    }
  }

  _onJobStop(
    StopJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    RefreshingJobModel jobToBeStopped = refreshingJobs[event.unitGroupName]!;

    jobToBeStopped.progressController?.close();

    RefreshingJobModel stoppedJob = RefreshingJobModel(
      name: jobToBeStopped.name,
      unitGroupName: jobToBeStopped.unitGroupName,
      refreshableDataPart: jobToBeStopped.refreshableDataPart,
      selectedCron: jobToBeStopped.selectedCron,
      dataSources: jobToBeStopped.dataSources,
      selectedDataSource: jobToBeStopped.selectedDataSource,
      lastRefreshTime: jobToBeStopped.lastRefreshTime,
      progressController: null,
    );

    refreshingJobs.update(event.unitGroupName, (value) => stoppedJob);

    emit(
      RefreshingJobsFetched(
        jobs: refreshingJobs,
      ),
    );
  }

  _onJobFinish(
    FinishJob event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, RefreshingJobModel> refreshingJobs = await _getAllJobs();

    RefreshingJobModel jobToBeFinished = refreshingJobs[event.unitGroupName]!;

    RefreshingJobModel completedJob = RefreshingJobModel(
      name: jobToBeFinished.name,
      unitGroupName: jobToBeFinished.unitGroupName,
      refreshableDataPart: jobToBeFinished.refreshableDataPart,
      selectedCron: jobToBeFinished.selectedCron,
      dataSources: jobToBeFinished.dataSources,
      selectedDataSource: jobToBeFinished.selectedDataSource,
      lastRefreshTime: DateTime.now().toString(),
      progressController: null,
    );

    refreshingJobs.update(event.unitGroupName, (value) => completedJob);

    emit(
      RefreshingJobsFetched(
        jobs: refreshingJobs,
        rebuiltConversion: event.rebuiltConversion,
      ),
    );
  }

  @override
  RefreshingJobsState? fromJson(Map<String, dynamic> json) {
    return RefreshingJobsFetched(
      jobs: (json["jobs"] as Map).map(
        (key, value) => MapEntry(key, RefreshingJobModel.fromJson(value)!),
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(RefreshingJobsState state) {
    if (state is RefreshingJobsFetched) {
      return {
        "jobs": state.jobs.map((key, value) => MapEntry(key, value.toJson())),
      };
    }
    return const {};
  }
}
