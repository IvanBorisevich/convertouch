import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final CalculateUnitValueUseValue calculateUnitValueUseValue;
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;

  const ReplaceConversionItemUnitUseCase({
    required this.calculateUnitValueUseValue,
    required this.calculateParamSetValueUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue = await ObjectUtils.tryGet(
      await calculateUnitValueUseValue.execute(
        InputUnitValueCalculationModel(
          itemValue: oldConvertedUnitValues[delta.unitId]!,
          conversionGroup: unitGroup,
          delta: delta,
          paramSetValue: params,
        ),
      ),
    );

    return oldConvertedUnitValues.map(
      (key, value) => key == delta.unitId
          ? MapEntry(delta.newUnit.id, newSrcUnitValue)
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

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParamsBySrcUnitValue({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required ConversionUnitValueModel srcUnitValue,
    required UnitGroupModel unitGroup,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    if (oldConversionParams == null || oldConversionParams.active == null) {
      return null;
    }

    if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
      return oldConversionParams;
    }

    ConversionParamSetValueModel newParamSetValue = ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: oldConversionParams.active!,
          srcUnitValue: srcUnitValue,
          conversionGroup: unitGroup,
          startParamId: null,
          enableFirstCalculableParamIfNoCalculatedEnabled: false,
        ),
      ),
    );

    return await oldConversionParams.copyWithChangedParamSetById(
      paramSetId: newParamSetValue.paramSet.id,
      map: (paramSetValue) async => newParamSetValue,
    );
  }
}
