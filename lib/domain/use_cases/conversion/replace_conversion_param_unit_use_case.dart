import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionParamUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionParamUnitDelta> {
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;

  const ReplaceConversionParamUnitUseCase({
    required this.calculateParamSetValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required ReplaceConversionParamUnitDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    ConversionParamSetValueModel oldParamSetValue =
        oldConversionParams.getParamSetValueById(delta.paramSetId);

    ConversionParamSetValueModel newParamSetValue = ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: oldParamSetValue,
          delta: delta,
          srcUnitValue: srcUnitValue,
          alignCurrentValues: true,
          unitGroupName: unitGroup.name,
          enableFirstCalculableParamIfNoCalculatedEnabled: false,
        ),
      ),
    );

    return await oldConversionParams.copyWithChangedParamSetById(
      paramSetId: delta.paramSetId,
      map: (paramSetValue) async => newParamSetValue,
    );
  }
}
