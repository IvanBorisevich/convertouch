import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/update_job_finish_time_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs_control/execute_job_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsControlBloc extends ConvertouchBloc<
    RefreshingJobsControlEvent, RefreshingJobsControlState> {
  final ExecuteJobUseCase executeJobUseCase;
  final UpdateJobFinishTimeUseCase updateJobFinishTimeUseCase;

  RefreshingJobsControlBloc({
    required this.executeJobUseCase,
    required this.updateJobFinishTimeUseCase,
  }) : super(const RefreshingJobsProgressUpdated(jobsInProgress: {})) {
    on<ExecuteJob>(_onJobExecute);
    on<StopJob>(_onJobStop);
    on<FinishJob>(_onJobFinish);
  }

  _onJobExecute(
    ExecuteJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    Map<int, RefreshingJobModel> jobsMap =
        event.jobsInProgress.isNotEmpty ? event.jobsInProgress : {};

    if (jobsMap.containsKey(event.job.id)) {
      emit(
        RefreshingJobsControlNotificationState(
          message: "Job '${event.job.name}' is running at the moment",
        ),
      );
      emit(
        RefreshingJobsProgressUpdated(
          jobsInProgress: event.jobsInProgress,
        ),
      );
      return;
    }

    final startedJobResult = await executeJobUseCase.execute(
      InputExecuteJobModel(
        job: event.job,
        conversionToBeRebuilt: event.conversionToBeRebuilt,
      ),
    );

    if (startedJobResult.isLeft) {
      ConvertouchException exception = startedJobResult.left;
      if (exception.severity == ExceptionSeverity.error) {
        emit(
          RefreshingJobsControlErrorState(
            exception: exception,
            lastSuccessfulState: state,
          ),
        );
      } else {
        emit(
          RefreshingJobsControlNotificationState(
            message: exception.message,
          ),
        );
        emit(
          RefreshingJobsProgressUpdated(
            jobsInProgress: event.jobsInProgress,
          ),
        );
      }
    } else {
      jobsMap.putIfAbsent(event.job.id!, () => startedJobResult.right);

      emit(
        RefreshingJobsProgressUpdated(
          jobsInProgress: jobsMap,
        ),
      );
    }
  }

  _onJobStop(
    StopJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    Map<int, RefreshingJobModel> jobsMap =
        event.jobsInProgress.isNotEmpty ? event.jobsInProgress : {};

    int jobId = event.job.id!;
    jobsMap.remove(jobId);

    emit(
      RefreshingJobsProgressUpdated(
        jobsInProgress: jobsMap,
      ),
    );
  }

  _onJobFinish(
    FinishJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    Map<int, RefreshingJobModel> jobsMap =
        event.jobsInProgress.isNotEmpty ? event.jobsInProgress : {};

    int jobId = event.job.id!;
    jobsMap.remove(jobId);

    final result = await updateJobFinishTimeUseCase.execute(
      event.job,
    );

    if (result.isLeft) {
      emit(
        RefreshingJobsControlErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      emit(
        RefreshingJobsProgressUpdated(
          jobsInProgress: jobsMap,
          completedJobId: jobId,
        ),
      );
    }
  }
}
