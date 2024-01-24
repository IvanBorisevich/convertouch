import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';

class InputStartJobModel {
  final RefreshingJobModel job;
  final InputConversionModel? conversionParamsToRefresh;

  const InputStartJobModel({
    required this.job,
    this.conversionParamsToRefresh,
  });
}