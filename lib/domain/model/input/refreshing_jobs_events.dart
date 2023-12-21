import 'package:equatable/equatable.dart';

abstract class RefreshingJobsEvent extends Equatable {
  const RefreshingJobsEvent();

  @override
  List<Object?> get props => [];
}

class FetchRefreshingJobs extends RefreshingJobsEvent {
  const FetchRefreshingJobs();

  @override
  String toString() {
    return 'FetchRefreshingJobs{}';
  }
}