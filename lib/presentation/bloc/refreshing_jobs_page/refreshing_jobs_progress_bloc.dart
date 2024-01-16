import 'dart:async';

import 'package:convertouch/domain/use_cases/refreshing_jobs/update_job_finish_time_use_case.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_data_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsProgressBloc
    extends ConvertouchBloc<RefreshingJobsEvent, RefreshingJobsState> {
  final RefreshDataUseCase refreshDataUseCase;
  final UpdateJobFinishTimeUseCase updateJobFinishTimeUseCase;

  RefreshingJobsProgressBloc({
    required this.refreshDataUseCase,
    required this.updateJobFinishTimeUseCase,
  }) : super(const RefreshingJobsProgressUpdated(progressValues: {})) {
    on<StartDataRefreshing>(_onDataRefreshingStart);
    on<StopDataRefreshing>(_onDataRefreshingStop);
    on<CompleteDataRefreshing>(_onDataRefreshingComplete);
  }

  _onDataRefreshingStart(
    StartDataRefreshing event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<int, Stream<double>?> progressValues = {};

    if (event.progressValues.isNotEmpty) {
      progressValues = event.progressValues;
    }

    emit(const RefreshingJobsProgressUpdating());

    var stream = _refreshData();

    progressValues.putIfAbsent(event.job.id!, () => stream);

    emit(
      RefreshingJobsProgressUpdated(
        progressValues: progressValues,
      ),
    );
  }

  _onDataRefreshingStop(
    StopDataRefreshing event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(const RefreshingJobsProgressUpdating());

    Map<int, Stream<double>?> progressValues = {};

    if (event.progressValues.isNotEmpty) {
      progressValues = event.progressValues;
    }

    progressValues.remove(event.job.id!);

    emit(
      RefreshingJobsProgressUpdated(
        progressValues: progressValues,
      ),
    );
  }

  _onDataRefreshingComplete(
    CompleteDataRefreshing event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(const RefreshingJobsProgressUpdating());

    Map<int, Stream<double>?> progressValues = {};
    int jobId = event.job.id!;

    if (event.progressValues.isNotEmpty) {
      progressValues = event.progressValues;
    }

    progressValues.remove(jobId);

    final result = await updateJobFinishTimeUseCase.execute(
      event.job,
    );

    if (result.isLeft) {
      emit(
        RefreshingJobsErrorState(
          message: result.left.message,
        ),
      );
    } else {
      emit(
        RefreshingJobsProgressUpdated(
          progressValues: progressValues,
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
