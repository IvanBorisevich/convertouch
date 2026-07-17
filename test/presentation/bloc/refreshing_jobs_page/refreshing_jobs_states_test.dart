import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:test/test.dart';

final _now = DateTime.now();
const _jobKey = "${GroupNames.currency}_${ParamSetNames.exchangeRate}";

void main() {
  test('Should serialize', () {
    expect(
      RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.everyHour,
            completedAt: _now,
          )
        },
      ).toJson(),
      {
        "jobs": {
          "Currency_Exchange Rate": {
            "selectedCron": "Every hour",
            "completedAt": _now.toString(),
          }
        }
      },
    );
  });

  group('Should deserialize', () {
    test('Should deserialize for backward compatible cases', () {
      expect(
        RefreshingJobsFetched.fromJson({
          "jobs": {
            "Currency": {
              "selectedCron": "Every hour",
              "completedAt": _now.toString(),
            }
          }
        }),
        RefreshingJobsFetched(
          jobs: {
            _jobKey: JobModel(
              cron: Cron.everyHour,
              completedAt: _now,
            )
          },
        ),
      );

      expect(
        RefreshingJobsFetched.fromJson({
          "jobs": {
            "Currency_Exchange Rate": {
              "selectedCron": "Every hour",
              "lastRefreshTime": _now.toString(),
            }
          }
        }),
        RefreshingJobsFetched(
          jobs: {
            _jobKey: JobModel(
              cron: Cron.everyHour,
              completedAt: _now,
            )
          },
        ),
      );
    });

    test('Should deserialize for new cases', () {
      expect(
        RefreshingJobsFetched.fromJson({
          "jobs": {
            "Currency_Exchange Rate": {
              "selectedCron": "Every hour",
              "completedAt": _now.toString(),
            }
          }
        }),
        RefreshingJobsFetched(
          jobs: {
            _jobKey: JobModel(
              cron: Cron.everyHour,
              completedAt: _now,
            )
          },
        ),
      );
    });
  });

  group("Should compare 2 states", () {
    test("States should be identical", () {
      const firstState = RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.never,
            executionMode: JobExecutionMode.continueAlreadyRunningJobIfAny,
          ),
        },
      );

      const secondState = RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.never,
            executionMode: JobExecutionMode.continueAlreadyRunningJobIfAny,
          ),
        },
      );

      expect(firstState == secondState, true);
    });

    test("States should NOT be identical", () async {
      final StreamController<JobResultModel> jobStreamController =
          StreamController.broadcast();

      final firstState = RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.never,
            completedAt: null,
            progressController: jobStreamController,
            executionMode: JobExecutionMode.continueAlreadyRunningJobIfAny,
          ),
        },
      );

      final secondState = RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.never,
            completedAt: DateTime.now(),
            progressController: null,
            executionMode: JobExecutionMode.continueAlreadyRunningJobIfAny,
          ),
        },
      );

      expect(firstState != secondState, true);

      await jobStreamController.close();
    });
  });
}
