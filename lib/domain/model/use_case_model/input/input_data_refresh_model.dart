import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class InputDataRefreshModel {
  final String unitGroupName;
  final ConversionParamSetValueModel params;

  const InputDataRefreshModel({
    required this.unitGroupName,
    required this.params,
  });
}
