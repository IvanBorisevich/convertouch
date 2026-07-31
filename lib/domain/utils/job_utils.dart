import 'package:async/async.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

typedef JobsMap = Map<String, JobModel>;
typedef JobsOperationsMap = Map<String, CancelableOperation<void>?>;

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
      params: jobPatch.params,
      status: jobPatch.status,
      completedAt: jobPatch.completedAt,
      cron: jobPatch.cron,
      progressController: Patchable(
        jobPatch.progressController,
        patchNull: true,
      ),
    ),
    ifAbsent: () => jobPatch,
  );

  return resultMap;
}

void patchJobsOperations(
  JobsOperationsMap map, {
  required String unitGroupName,
  required String paramSetName,
  required CancelableOperation<void>? jobOperation,
}) {
  map.update(
    _jobKey(unitGroupName, paramSetName),
    (_) => jobOperation,
    ifAbsent: () => jobOperation,
  );
}

Future<void> cancelJobOperation(
  JobsOperationsMap map, {
  required String unitGroupName,
  required String paramSetName,
}) async {
  final jobOperation = map.remove(_jobKey(unitGroupName, paramSetName));
  await _cancelJobOperation(jobOperation);
}

Future<void> cancelAllJobOperations(JobsOperationsMap map) async {
  for (var jobOperation in map.values) {
    await _cancelJobOperation(jobOperation);
  }
}

Future<void> _cancelJobOperation(CancelableOperation<void>? operation) async {
  if (operation != null && !operation.isCanceled) {
    await operation.cancel();
  }
}

String _jobKey(String unitGroupName, String paramSetName) =>
    "${unitGroupName}_$paramSetName";
