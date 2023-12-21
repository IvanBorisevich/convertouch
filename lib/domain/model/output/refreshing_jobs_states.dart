import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:equatable/equatable.dart';

abstract class RefreshingJobsState extends Equatable {
  const RefreshingJobsState();

  @override
  List<Object?> get props => [];
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
    return 'RefreshingJobsFetched{items: $items}';
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