import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

enum DynamicDataType { coefficients, singleValue }

const Map<String, DynamicDataType> dynamicDataGroups = {
  GroupNames.currency: DynamicDataType.coefficients,
  GroupNames.temperature: DynamicDataType.singleValue,
};

abstract class InputDynamicDataFetchModel {
  const InputDynamicDataFetchModel();
}

class InputDynamicCoefficientsFetchModel extends InputDynamicDataFetchModel {
  final ConversionParamSetValueModel params;

  const InputDynamicCoefficientsFetchModel({
    required this.params,
  });
}

class InputDynamicValueFetchModel extends InputDynamicDataFetchModel {
  final UnitModel srcUnit;
  final ConversionParamSetValueModel? params;

  const InputDynamicValueFetchModel({
    required this.srcUnit,
    this.params,
  });
}
