import 'package:convertouch/domain/model/output/abstract_state.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

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
  final Map<int, Stream<int>> dataRefreshingProgress;

  const RefreshingJobsFetched({
    required this.items,
    this.dataRefreshingProgress = const {},
  });

  @override
  List<Object?> get props => [
    items,
    dataRefreshingProgress,
  ];

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'items: $items}';
  }
}

class RefreshingJobsErrorState extends RefreshingJobsState {
  final String message;

  const RefreshingJobsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'RefreshingJobsErrorState{message: $message}';
  }
}