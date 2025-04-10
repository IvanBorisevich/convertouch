import 'package:convertouch/domain/model/conversion_param_set_model.dart';

class InputParamSetValuesCreateModel {
  final ConversionParamSetModel? paramSet;
  final int groupId;

  const InputParamSetValuesCreateModel({
    this.paramSet,
    required this.groupId,
  });
}
