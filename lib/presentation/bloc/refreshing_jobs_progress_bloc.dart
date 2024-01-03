import 'dart:async';

import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/refresh_data_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsProgressBloc
    extends ConvertouchBloc<RefreshingJobsEvent, RefreshingJobsState> {
  final RefreshDataUseCase refreshDataUseCase;

  RefreshingJobsProgressBloc({
    required this.refreshDataUseCase,
  }) : super(const RefreshingJobsProgressUpdated(progressValues: {})) {
    on<RefreshData>(_onDataRefresh);
  }

  _onDataRefresh(
    RefreshData event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<int, Stream<double>?> progressValues = {};

    if (event.progressValues.isNotEmpty) {
      progressValues = event.progressValues;
    }

    int jobId = event.job.id!;

    if (progressValues.containsKey(jobId)) {
      progressValues.remove(jobId);
      emit(const RefreshingJobsProgressUpdating());
      emit(
        RefreshingJobsProgressUpdated(
          progressValues: progressValues,
        ),
      );
    } else {
      emit(const RefreshingJobsProgressUpdating());

      var stream = _refreshData();

      progressValues.putIfAbsent(jobId, () => stream);

      emit(
        RefreshingJobsProgressUpdated(
          progressValues: progressValues,
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
