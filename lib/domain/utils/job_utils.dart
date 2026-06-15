import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

typedef JobsMap = Map<String, JobModel>;

JobsMap patchJobsMap(
  JobsMap activeJobs, {
  required String unitGroupName,
  required String paramSetName,
  required JobModel jobPatch,
}) {
  var resultMap = ObjectUtils.copyMap(activeJobs);

  resultMap.update(
    jobKey(unitGroupName, paramSetName),
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

String jobKey(String unitGroupName, String paramSetName) =>
    "${unitGroupName}_$paramSetName";
