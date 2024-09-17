import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final Map<String, JobModel> jobs;
  final Map<String, String> currentDataSources;

  const RefreshingJobsFetched({
    required this.jobs,
    required this.currentDataSources,
  });

  @override
  List<Object?> get props => [
        jobs.entries,
        currentDataSources.entries,
      ];

  Map<String, dynamic> toJson() {
    return {
      "jobs": jobs.map((key, value) => MapEntry(key, value.toJson())),
      "currentDataSources": currentDataSources,
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
      currentDataSources: ObjectUtils.convertToMap(json["currentDataSources"]),
    );
  }

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'jobs: $jobs, '
        'currentDataSources: $currentDataSources}';
  }
}
