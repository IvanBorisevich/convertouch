import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

typedef JobsMap = Map<String, JobModel>;

JobModel? findJob(
  JobsMap activeJobs, {
  required String unitGroupName,
  required String? paramSetName,
}) {
  return paramSetName != null
      ? activeJobs[_jobKey(unitGroupName, paramSetName)]
      : null;
}

JobsMap patchJobsMap(
  JobsMap activeJobs, {
  required String unitGroupName,
  required String paramSetName,
  required JobModel jobPatch,
}) {
  var resultMap = ObjectUtils.copyMap(activeJobs);

  resultMap.update(
    _jobKey(unitGroupName, paramSetName),
    (job) => job.copyWith(
      params: Patchable(jobPatch.params),
      completedAt: Patchable(jobPatch.completedAt),
      cron: Patchable(jobPatch.cron),
      progressController: Patchable(
        jobPatch.progressController,
        patchNull: true,
      ),
    ),
    ifAbsent: () => jobPatch,
  );

  return resultMap;
}

String _jobKey(String unitGroupName, String paramSetName) =>
    "${unitGroupName}_$paramSetName";
