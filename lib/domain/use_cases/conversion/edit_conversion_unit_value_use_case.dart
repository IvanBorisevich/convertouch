import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionUnitValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionUnitValueDelta> {
  final CalculateUnitValueUseValue calculateUnitValueUseValue;
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;

  const EditConversionUnitValueUseCase({
    required this.calculateUnitValueUseValue,
    required this.calculateParamSetValueUseCase,
  });

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required EditConversionUnitValueDelta delta,
  }) async {
    return ObjectUtils.tryGet(
      await calculateUnitValueUseValue.execute(
        InputUnitValueCalculationModel(
          unitValue: newConvertedUnitValues[delta.unitId]!,
          delta: delta,
          paramSetValue: activeParams,
          alignCurrentValue: true,
        ),
      ),
    );
  }

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParamsBySrcUnitValue({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required ConversionUnitValueModel srcUnitValue,
    required UnitGroupModel unitGroup,
    required EditConversionUnitValueDelta delta,
  }) async {
    if (oldConversionParams == null || oldConversionParams.active == null) {
      return null;
    }

    ConversionParamSetValueModel newParamSetValue = ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: oldConversionParams.active!,
          srcUnitValue: srcUnitValue,
          unitGroupName: unitGroup.name,
          alignCurrentValues: true,
          enableFirstCalculableParamIfNoCalculatedEnabled: false,
        ),
      ),
    );

    return oldConversionParams.copyWithChangedParamSetById(
      paramSetId: newParamSetValue.paramSet.id,
      map: (paramSetValue) async => newParamSetValue,
    );
  }
}
