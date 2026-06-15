import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/job_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

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

  JobModel? getJob(String unitGroupName, String? paramSetName) {
    return paramSetName != null
        ? jobs[jobKey(unitGroupName, paramSetName)]
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "jobs": jobs.map(
        (key, value) => MapEntry(
          key,
          value.toJson(),
        ),
      ),
    };
  }

  static RefreshingJobsFetched? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return RefreshingJobsFetched(
      jobs: ObjectUtils.convertToMap<JobModel>(
        json["jobs"],
        keyMapFunc: (key) => key == GroupNames.currency
            ? "${GroupNames.currency}_${ParamSetNames.exchangeRate}"
            : key,
        valueMapFunc: (key, value) => JobModel.fromJson(value)!,
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
