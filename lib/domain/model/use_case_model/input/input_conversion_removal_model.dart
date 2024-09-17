import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class InputConversionRemovalModel {
  final List<int> removedGroupIds;
  final OutputConversionModel currentConversion;

  const InputConversionRemovalModel({
    required this.removedGroupIds,
    required this.currentConversion,
  });
}
