import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class InputExecuteJobModel {
  final RefreshingJobModel job;
  final OutputConversionModel? conversionToBeRebuilt;

  const InputExecuteJobModel({
    required this.job,
    this.conversionToBeRebuilt,
  });
}
