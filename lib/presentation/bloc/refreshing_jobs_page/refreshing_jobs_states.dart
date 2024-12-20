import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final Map<String, JobModel> jobs;
  final Map<String, String> currentDataSourceKeys;
  final String? currentDataSourceUrl;
  final DateTime? currentLastRefreshed;
  final String? currentLastRefreshedStr;

  const RefreshingJobsFetched({
    required this.jobs,
    required this.currentDataSourceKeys,
    this.currentDataSourceUrl,
    this.currentLastRefreshed,
    this.currentLastRefreshedStr,
  });

  @override
  List<Object?> get props => [
        jobs.entries,
        currentDataSourceKeys.entries,
        currentDataSourceUrl,
        currentLastRefreshed,
      ];

  Map<String, dynamic> toJson() {
    return {
      "jobs": jobs.map((key, value) => MapEntry(key, value.toJson())),
      "currentDataSources": currentDataSourceKeys,
      "currentDataSourceUrl": currentDataSourceUrl,
      "currentCompletedAt": currentLastRefreshed.toString(),
    };
  }

  static RefreshingJobsFetched? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return RefreshingJobsFetched(
      jobs: ObjectUtils.convertToMap(
        json["jobs"],
        valueMapFunc: (value) => JobModel.fromJson(value)!,
      ),
      currentDataSourceKeys:
          ObjectUtils.convertToMap(json["currentDataSources"]),
      currentDataSourceUrl: json["currentDataSourceUrl"],
      currentLastRefreshed:
          ObjectUtils.isNotNullOrEmpty(json["currentCompletedAt"])
              ? DateTime.parse(json["currentCompletedAt"])
              : null,
    );
  }

  RefreshingJobsFetched copyWith({
    Map<String, JobModel>? jobs,
    Map<String, String>? currentDataSourceKeys,
    String? currentDataSourceUrl,
    DateTime? currentLastRefreshed,
    String? currentLastRefreshedStr,
  }) {
    return RefreshingJobsFetched(
      jobs: jobs ?? this.jobs,
      currentDataSourceKeys:
          currentDataSourceKeys ?? this.currentDataSourceKeys,
      currentDataSourceUrl: currentDataSourceUrl ?? this.currentDataSourceUrl,
      currentLastRefreshed: currentLastRefreshed ?? this.currentLastRefreshed,
      currentLastRefreshedStr:
          currentLastRefreshedStr ?? this.currentLastRefreshedStr,
    );
  }

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'jobs: $jobs, '
        'currentDataSources: $currentDataSourceKeys, '
        'currentDataSourceName: $currentDataSourceUrl, '
        'currentCompletedAt: $currentLastRefreshed}';
  }
}
