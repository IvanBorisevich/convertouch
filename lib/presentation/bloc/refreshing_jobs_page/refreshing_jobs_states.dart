import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetching extends RefreshingJobsState {
  const RefreshingJobsFetching();

  @override
  String toString() {
    return 'RefreshingJobsFetching{}';
  }
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final List<RefreshingJobModel> items;

  const RefreshingJobsFetched({
    required this.items,
  });

  @override
  List<Object?> get props => [
        items,
      ];

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'items: $items}';
  }
}

class RefreshingJobsErrorState extends ConvertouchErrorState
    implements RefreshingJobsState {
  const RefreshingJobsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'RefreshingJobsErrorState{'
        'exception: $exception}';
  }
}
