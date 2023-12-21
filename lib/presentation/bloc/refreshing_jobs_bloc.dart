import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/usecases/refreshable_data_items/fetch_refreshing_jobs_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends Bloc<RefreshingJobsEvent, RefreshingJobsState> {
  final FetchRefreshingJobsUseCase fetchRefreshingJobsUseCase;

  RefreshingJobsBloc({
    required this.fetchRefreshingJobsUseCase,
  }) : super(const RefreshingJobsFetched(items: [])) {
    on<FetchRefreshingJobs>(_onRefreshingJobsFetch);
  }

  _onRefreshingJobsFetch(
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
      emit(refreshJobsResult.right);
    }
  }
}
