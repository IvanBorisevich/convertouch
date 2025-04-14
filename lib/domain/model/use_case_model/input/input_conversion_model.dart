import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModel {
  final UnitGroupModel unitGroup;
  final ConversionUnitValueModel sourceUnitValue;
  final ConversionParamSetValueBulkModel? params;
  final List<UnitModel> targetUnits;
  final int? conversionId;

  const InputConversionModel({
    required this.unitGroup,
    required this.sourceUnitValue,
    this.params,
    this.targetUnits = const [],
    this.conversionId,
  });

  @override
  String toString() {
    return 'InputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceUnitValue: $sourceUnitValue, '
        'params: $params, '
        'targetUnits: $targetUnits}';
  }
}
