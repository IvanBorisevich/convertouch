import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const ReplaceConversionItemUnitUseCase({
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel oldUnitValue =
        oldConvertedUnitValues[delta.unitId]!;

    ConversionUnitValueModel newUnitValue = ObjectUtils.tryGet(
      await calculateUnitValueUseValue.execute(
        InputUnitValueCalculationModel(
          unitValue: oldUnitValue,
          delta: delta,
          paramSetValue: params,
          alignCurrentValue: true,
        ),
      ),
    );

    return oldConvertedUnitValues.map(
      (key, value) => key == delta.unitId
          ? MapEntry(delta.newUnit.id, newUnitValue)
          : MapEntry(key, value),
    );
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    return newConvertedUnitValues[delta.newUnit.id]!;
  }
}
