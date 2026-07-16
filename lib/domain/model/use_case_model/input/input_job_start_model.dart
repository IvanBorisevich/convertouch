import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';

class InputJobStartModel {
  final JobModel job;
  final Future<DynamicDataModel?> Function(InputDynamicDataFetchModel? params)
      onExecute;

  const InputJobStartModel({
    required this.job,
    required this.onExecute,
  });
}
