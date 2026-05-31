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

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const EditConversionParamValueUseCase({
    required this.calculateParamSetValueUseCase,
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required EditConversionParamValueDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    final newParamSetValue = ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue:
              oldConversionParams.getParamSetValueById(delta.paramSetId),
          delta: delta,
          alignCurrentValues: true,
          enableFirstCalculableParamIfNoCalculatedEnabled: false,
        ),
      ),
    );

    return await oldConversionParams.copyWithChangedParamSetById(
      paramSetId: delta.paramSetId,
      map: (paramSetValue) async => newParamSetValue,
    );
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required EditConversionParamValueDelta delta,
  }) async {
    return ObjectUtils.tryGet(
      await calculateUnitValueUseValue.execute(
        InputUnitValueCalculationModel(
          unitValue: oldSourceUnitValue,
          paramSetValue: activeParams,
          calculateByParams: true,
          unitGroupName: unitGroup.name,
          alignCurrentValue: true,
        ),
      ),
    );
  }
}
