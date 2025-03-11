import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ConversionParamSetValuesModel {
  final ConversionParamSetModel paramSet;
  final List<ConversionParamValueModel> values;

  const ConversionParamSetValuesModel({
    required this.paramSet,
    required this.values,
  });

  Map<String, dynamic> toJson() {
    return {
      "paramSet": paramSet.toJson(),
      "values": values.map((value) => value.toJson()).toList(),
    };
  }

  ValueModel getValue(String paramName) {
    return values.firstWhere((e) => e.param.name == paramName).value;
  }

  static ConversionParamSetValuesModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetValuesModel(
      paramSet: ConversionParamSetModel.fromJson(json["paramSet"])!,
      values: (json["values"] as List)
          .map((value) => ConversionParamValueModel.fromJson(value)!)
          .toList(),
    );
  }
}
