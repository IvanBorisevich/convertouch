import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:test/test.dart';
import 'package:timeago/timeago.dart' as timeago;

final _now = DateTime.now();

void main() {
  test('Should serialize', () {
    expect(
      RefreshingJobsFetched(
        jobs: {
          GroupNames.currency: {
            ParamSetNames.exchangeRate: JobModel(
              selectedCron: Cron.everyHour,
              completedAt: _now,
            )
          }
        },
      ).toJson(),
      {
        "jobs": {
          "Currency": {
            "Exchange Rate": {
              "selectedCron": "Every hour",
              "completedAt": _now.toString(),
            }
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
            GroupNames.currency: {
              ParamSetNames.exchangeRate: JobModel(
                selectedCron: Cron.everyHour,
                completedAt: _now,
                completedAgo: timeago.format(_now),
              )
            }
          },
        ),
      );

      expect(
        RefreshingJobsFetched.fromJson({
          "jobs": {
            "Currency": {
              "selectedCron": "Every hour",
              "lastRefreshTime": _now.toString(),
            }
          }
        }),
        RefreshingJobsFetched(
          jobs: {
            GroupNames.currency: {
              ParamSetNames.exchangeRate: JobModel(
                selectedCron: Cron.everyHour,
                completedAt: _now,
                completedAgo: timeago.format(_now),
              )
            }
          },
        ),
      );
    });

    test('Should deserialize for new cases', () {
      expect(
        RefreshingJobsFetched.fromJson({
          "jobs": {
            "Currency": {
              "Exchange Rate": {
                "selectedCron": "Every hour",
                "completedAt": _now.toString(),
              }
            }
          }
        }),
        RefreshingJobsFetched(
          jobs: {
            GroupNames.currency: {
              ParamSetNames.exchangeRate: JobModel(
                selectedCron: Cron.everyHour,
                completedAt: _now,
                completedAgo: timeago.format(_now),
              )
            }
          },
        ),
      );
    });
  });
}
