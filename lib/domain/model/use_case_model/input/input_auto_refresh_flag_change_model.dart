import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

class InputAutoRefreshFlagChangeModel {
  final RefreshingJobModel job;
  final JobAutoRefresh newFlag;

  const InputAutoRefreshFlagChangeModel({
    required this.job,
    required this.newFlag,
  });
}
