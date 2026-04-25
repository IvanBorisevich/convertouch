import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

typedef JobsMap = Map<String, Map<String, JobModel>>;

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final JobsMap jobs;

  const RefreshingJobsFetched({
    required this.jobs,
  });

  @override
  List<Object?> get props => [
        jobs,
      ];

  Map<String, dynamic> toJson() {
    return {
      "jobs": jobs.map(
        (key, value) => MapEntry(
          key,
          value.map((k, v) => MapEntry(k, v.toJson())),
        ),
      ),
    };
  }

  static RefreshingJobsFetched? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return RefreshingJobsFetched(
      jobs: ObjectUtils.convertToMap<Map<String, JobModel>>(
        json["jobs"],
        valueMapFunc: (key, value) {
          /* support backward compatible format for 'Currency' group
              (without param set name key) */
          if (value is! Map<String, Map>) {
            return key == GroupNames.currency
                ? {
                    ParamSetNames.exchangeRate: JobModel.fromJson(value)!,
                  }
                : {};
          }

          return ObjectUtils.convertToMap<JobModel>(
            value,
            valueMapFunc: (key, value) => JobModel.fromJson(value)!,
          );
        },
      ),
    );
  }

  RefreshingJobsFetched copyWith({
    JobsMap? jobs,
  }) {
    return RefreshingJobsFetched(
      jobs: jobs ?? this.jobs,
    );
  }

  @override
  String toString() {
    return 'RefreshingJobsFetched{jobs: $jobs}';
  }
}
