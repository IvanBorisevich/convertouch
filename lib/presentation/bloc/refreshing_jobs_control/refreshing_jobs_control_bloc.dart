import 'dart:async';

import 'package:convertouch/domain/use_cases/refresh_data/refresh_data_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/update_job_finish_time_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsControlBloc extends ConvertouchBloc<
    RefreshingJobsControlEvent, RefreshingJobsControlState> {
  final RefreshDataUseCase refreshDataUseCase;
  final UpdateJobFinishTimeUseCase updateJobFinishTimeUseCase;

  RefreshingJobsControlBloc({
    required this.refreshDataUseCase,
    required this.updateJobFinishTimeUseCase,
  }) : super(const RefreshingJobsProgressUpdated(jobsProgress: {})) {
    on<StartJob>(_onJobStart);
    on<StopJob>(_onJobStop);
    on<FinishJob>(_onJobFinish);
  }

  _onJobStart(
    StartJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    Map<int, Stream<double>?> jobsProgress =
        event.jobsProgress.isNotEmpty ? event.jobsProgress : {};

    emit(const RefreshingJobsProgressUpdating());

    var stream = _refreshData();

    jobsProgress.putIfAbsent(event.job.id!, () => stream);

    emit(
      RefreshingJobsProgressUpdated(
        jobsProgress: jobsProgress,
      ),
    );
  }

  _onJobStop(
    StopJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    emit(const RefreshingJobsProgressUpdating());

    Map<int, Stream<double>?> jobsProgress =
        event.jobsProgress.isNotEmpty ? event.jobsProgress : {};

    jobsProgress.remove(event.job.id!);

    emit(
      RefreshingJobsProgressUpdated(
        jobsProgress: jobsProgress,
      ),
    );
  }

  _onJobFinish(
    FinishJob event,
    Emitter<RefreshingJobsControlState> emit,
  ) async {
    emit(const RefreshingJobsProgressUpdating());

    Map<int, Stream<double>?> progressValues = {};
    int jobId = event.job.id!;

    if (event.jobsProgress.isNotEmpty) {
      progressValues = event.jobsProgress;
    }

    progressValues.remove(jobId);

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
          jobsProgress: progressValues,
          completedJobId: jobId,
        ),
      );
    }
  }

  Stream<double> _refreshData() {
    return (() {
      late final StreamController<double> controller;
      controller = StreamController<double>(
        onListen: () async {
          await Future.forEach(
            List.generate(10, (i) => i + 1),
            (int i) async {
              controller.add(i / 10);

              await Future.delayed(
                const Duration(seconds: 1),
              );
            },
          );

          await controller.close();
        },
      );
      return controller.stream;
    })();
  }
}
