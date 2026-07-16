import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/utils/job_utils.dart';
import 'package:test/test.dart';

const _jobKey = "${GroupNames.currency}_${ParamSetNames.exchangeRate}";

void main() {
  test('Should add a new job to the map', () {
    expect(
      patchJobsMap(
        {},
        unitGroupName: GroupNames.currency,
        paramSetName: ParamSetNames.exchangeRate,
        jobPatch: const JobModel(
          cron: Cron.never,
        ),
      ),
      {
        _jobKey: const JobModel(
          cron: Cron.never,
        ),
      },
    );
  });

  test('Should update existing job in the map', () async {
    final jobsController = StreamController<JobResultModel>.broadcast();
    final completedAt = DateTime.now();

    expect(
      patchJobsMap(
        {
          _jobKey: JobModel(
            cron: Cron.never,
            completedAt: completedAt,
          ),
        },
        unitGroupName: GroupNames.currency,
        paramSetName: ParamSetNames.exchangeRate,
        jobPatch: JobModel(
          cron: Cron.never,
          completedAt: completedAt,
          progressController: jobsController,
        ),
      ),
      {
        _jobKey: JobModel(
          cron: Cron.never,
          completedAt: completedAt,
          progressController: jobsController,
        ),
      },
    );

    expect(
      patchJobsMap(
        {
          _jobKey: JobModel(
            cron: Cron.never,
            progressController: jobsController,
          ),
        },
        unitGroupName: GroupNames.currency,
        paramSetName: ParamSetNames.exchangeRate,
        jobPatch: JobModel(
          cron: Cron.never,
          completedAt: completedAt,
        ),
      ),
      {
        _jobKey: JobModel(
          cron: Cron.never,
          completedAt: completedAt,
        ),
      },
    );

    await jobsController.close();
  });
}
