import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';

class JobResultModel {
  final double progressPercent;
  final ConvertouchException? notification;
  final DynamicDataModel? result;

  const JobResultModel({
    this.result,
    required this.progressPercent,
    this.notification,
  });

  const JobResultModel.start()
      : this(
          progressPercent: 0.0,
        );

  const JobResultModel.finish(
    DynamicDataModel? result, {
    ConvertouchException? info,
  }) : this(
          result: result,
          progressPercent: 1.0,
          notification: info,
        );

  const JobResultModel.noResult()
      : this(
          progressPercent: -1,
        );

  @override
  String toString() {
    return 'JobResultModel{'
        'progressPercent: $progressPercent, '
        'notification: $notification}';
  }
}
