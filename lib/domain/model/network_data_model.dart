import 'package:convertouch/domain/model/dynamic_value_model.dart';

class NetworkDataModel {
  final Map<String, double?>? dynamicCoefficients;
  final DynamicValueModel? dynamicValue;

  const NetworkDataModel({
    this.dynamicCoefficients,
    this.dynamicValue,
  });
}