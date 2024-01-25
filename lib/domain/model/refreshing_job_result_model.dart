import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';

class RefreshingJobResultModel {
  final double progressPercent;
  final InputConversionModel? refreshedConversionParams;

  const RefreshingJobResultModel({
    required this.progressPercent,
    this.refreshedConversionParams,
  });

  const RefreshingJobResultModel.start()
      : this(
          progressPercent: 0.0,
        );

  const RefreshingJobResultModel.finish({
    InputConversionModel? refreshedConversionParams,
  }) : this(
          progressPercent: 1.0,
          refreshedConversionParams: refreshedConversionParams,
        );
}
