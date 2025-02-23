import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';

class ConversionParamSetValuesModel {
  final ConversionParamSetModel paramSet;
  final Map<String, ConversionParamValueModel> paramValues;

  const ConversionParamSetValuesModel({
    required this.paramSet,
    required this.paramValues,
  });

  Map<String, dynamic> toJson() {
    return {
      "paramSet": paramSet.toJson(),
      "paramValues": paramValues.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  static ConversionParamSetValuesModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetValuesModel(
      paramSet: ConversionParamSetModel.fromJson(json["paramSet"])!,
      paramValues: (json["paramValues"] as Map).map(
        (key, value) => MapEntry(
          key,
          ConversionParamValueModel.fromJson(value)!,
        ),
      ),
    );
  }
}
