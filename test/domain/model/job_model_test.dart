import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:test/test.dart';
import 'package:timeago/timeago.dart' as timeago;

final _now = DateTime.now();

void main() {
  test('Should serialize', () {
    expect(
      JobModel(
        selectedCron: Cron.everyHour,
        completedAt: _now,
      ).toJson(),
      {
        "selectedCron": "Every hour",
        "completedAt": _now.toString(),
      },
    );
  });

  group('Should deserialize', () {
    test('Should deserialize for backward compatible cases', () {
      expect(
        JobModel.fromJson({
          "selectedCron": "Every hour",
          "lastRefreshTime": _now.toString(),
        }),
        JobModel(
          selectedCron: Cron.everyHour,
          completedAt: _now,
          completedAgo: timeago.format(_now),
        ),
      );
    });

    test('Should deserialize for new cases', () {
      expect(
        JobModel.fromJson({
          "selectedCron": "Every hour",
          "completedAt": _now.toString(),
        }),
        JobModel(
          selectedCron: Cron.everyHour,
          completedAt: _now,
          completedAgo: timeago.format(_now),
        ),
      );
    });
  });
}
