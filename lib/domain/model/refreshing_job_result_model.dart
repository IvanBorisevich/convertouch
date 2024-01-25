import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class RefreshingJobResultModel {
  final double progressPercent;
  final OutputConversionModel? rebuiltConversion;

  const RefreshingJobResultModel({
    required this.progressPercent,
    this.rebuiltConversion,
  });

  const RefreshingJobResultModel.start()
      : this(
          progressPercent: 0.0,
        );

  const RefreshingJobResultModel.finish({
    OutputConversionModel? rebuiltConversion,
  }) : this(
          progressPercent: 1.0,
          rebuiltConversion: rebuiltConversion,
        );
}
