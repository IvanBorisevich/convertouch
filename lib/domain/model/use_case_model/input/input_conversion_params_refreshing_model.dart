import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';

class InputConversionParamsRefreshingModel {
  final InputConversionModel conversionParamsToBeRefreshed;
  final RefreshableDataPart refreshableDataPart;
  final List<dynamic> refreshedData;

  const InputConversionParamsRefreshingModel({
    required this.conversionParamsToBeRefreshed,
    required this.refreshableDataPart,
    required this.refreshedData,
  });

  @override
  String toString() {
    return 'InputConversionParamsRefreshingModel{'
        'conversionParamsToBeRefreshed: $conversionParamsToBeRefreshed, '
        'refreshableDataPart: $refreshableDataPart, '
        'refreshedData: $refreshedData}';
  }
}