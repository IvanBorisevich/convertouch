import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/fetch_refreshing_jobs_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/start_refreshing_data_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchBloc<RefreshingJobsEvent, RefreshingJobsState> {
  final FetchRefreshingJobsUseCase fetchRefreshingJobsUseCase;
  final StartRefreshingDataUseCase startRefreshingDataUseCase;

  RefreshingJobsBloc({
    required this.fetchRefreshingJobsUseCase,
    required this.startRefreshingDataUseCase,
  }) : super(const RefreshingJobsFetched(items: [])) {
    on<FetchRefreshingJobs>(_onJobsFetch);
    on<StartRefreshingData>(_onDataRefreshingToggle);
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(const RefreshingJobsFetching());

    final refreshJobsResult = await fetchRefreshingJobsUseCase.execute();

    if (refreshJobsResult.isLeft) {
      emit(RefreshingJobsErrorState(
        message: refreshJobsResult.left.message,
      ));
    } else {
      emit(
        RefreshingJobsFetched(
          items: refreshJobsResult.right,
        ),
      );
    }
  }

  _onDataRefreshingToggle(
    StartRefreshingData event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(const RefreshingJobsFetching());

    final result = await startRefreshingDataUseCase.execute(event);
    if (result.isLeft) {
      emit(
        RefreshingJobsErrorState(
          message: result.left.message,
        ),
      );
    } else {
      emit(result.right);
    }
  }
}
