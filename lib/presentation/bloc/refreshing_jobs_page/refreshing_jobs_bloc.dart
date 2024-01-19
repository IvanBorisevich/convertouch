import 'package:convertouch/domain/use_cases/refreshing_jobs/get_jobs_list_use_case.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchBloc<RefreshingJobsEvent, RefreshingJobsState> {
  final GetJobsListUseCase getJobsListUseCase;

  RefreshingJobsBloc({
    required this.getJobsListUseCase,
  }) : super(const RefreshingJobsFetched(items: [])) {
    on<FetchRefreshingJobs>(_onJobsFetch);
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    emit(const RefreshingJobsFetching());

    final refreshJobsResult = await getJobsListUseCase.execute();

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
}
