import 'package:async/async.dart';
import 'package:convertouch/domain/model/job_model.dart';

class OutputJobStartModel {
  final JobModel job;
  final CancelableOperation<void>? jobOperation;

  const OutputJobStartModel({
    required this.job,
    this.jobOperation,
  });
}
