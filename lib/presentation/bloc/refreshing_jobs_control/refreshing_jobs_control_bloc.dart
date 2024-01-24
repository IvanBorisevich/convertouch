import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/update_job_finish_time_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs_control/start_job_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsControlBloc extends ConvertouchBloc<
    RefreshingJobsControlEvent, RefreshingJobsControlState> {
  final StartJobUseCase startJobUseCase;
  final UpdateJobFinishTimeUseCase updateJobFinishTimeUseCase;

  RefreshingJobsControlBloc({
    required this.startJobUseCase,
    required this.updateJobFinishTimeUseCase,
  }) : super(const RefreshingJobsProgressUpdated(jobsInProgress: {})) {
    on<StartJob>(_onJobStart);
    on<StopJob>(_onJobStop);
    on<FinishJob>(_onJobFinish);
  }

  _onJobStart(
    StartJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    Map<int, RefreshingJobModel> jobsMap =
        event.jobsInProgress.isNotEmpty ? event.jobsInProgress : {};

    emit(const RefreshingJobsProgressUpdating());

    if (jobsMap.containsKey(event.job.id)) {
      emit(
        RefreshingJobsControlErrorState(
          message: "Job with id = ${event.job.id} is running at the moment",
        ),
      );
      return;
    }

    InputConversionModel? conversionToRebuild;

    if (event.conversionToRebuild != null) {
      conversionToRebuild = InputConversionModel(
        unitGroup: event.conversionToRebuild!.unitGroup,
        sourceConversionItem: event.conversionToRebuild!.sourceConversionItem,
        targetUnits: event.conversionToRebuild!.targetConversionItems
            .map((item) => item.unit)
            .toList(),
      );
    }

    final startedJobResult = await startJobUseCase.execute(
      InputStartJobModel(
        job: event.job,
        conversionParamsToRefresh: conversionToRebuild,
      ),
    );

    if (startedJobResult.isLeft) {
      emit(
        RefreshingJobsControlErrorState(
          message: startedJobResult.left.message,
        ),
      );
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
    emit(const RefreshingJobsProgressUpdating());

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
    emit(const RefreshingJobsProgressUpdating());

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
          message: result.left.message,
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
