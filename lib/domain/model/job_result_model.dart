import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';

class JobResultModel {
  final double progressPercent;
  final ConvertouchException? notification;
  final DynamicDataModel? data;

  const JobResultModel({
    this.data,
    required this.progressPercent,
    this.notification,
  });

  const JobResultModel.finish(
    DynamicDataModel? result, {
    ConvertouchException? info,
  }) : this(
          data: result,
          progressPercent: 1.0,
          notification: info,
        );

  const JobResultModel.failure(ConvertouchException error)
      : this(
          progressPercent: -1,
          notification: error,
        );

  bool get finished => progressPercent == 1;

  bool get failed => progressPercent == -1;

  @override
  String toString() {
    return 'JobResultModel{'
        'progressPercent: $progressPercent, '
        'notification: $notification}';
  }
}
