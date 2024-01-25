import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class InputConversionRebuildModel {
  final OutputConversionModel conversionToBeRebuilt;
  final RefreshableDataPart refreshableDataPart;
  final List<dynamic> refreshedData;

  const InputConversionRebuildModel({
    required this.conversionToBeRebuilt,
    required this.refreshableDataPart,
    required this.refreshedData,
  });

  @override
  String toString() {
    return 'InputConversionParamsRefreshingModel{'
        'conversionToBeRebuilt: $conversionToBeRebuilt, '
        'refreshableDataPart: $refreshableDataPart, '
        'refreshedData: $refreshedData}';
  }
}
