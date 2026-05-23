import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_source_item_by_params_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  final InitParamListValuesUseCase initParamListValuesUseCase;
  final CalculateSourceItemByParamsUseCase calculateSourceItemByParamsUseCase;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const EditConversionParamValueUseCase({
    required this.initParamListValuesUseCase,
    required this.calculateSourceItemByParamsUseCase,
    required this.calculateDefaultValueUseCase,
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

    final modifiedParams = await oldConversionParams.copyWithChangedParamById(
      paramSetId: delta.paramSetId,
      paramId: delta.paramId,
      map: (paramValue, paramSetValue) async {
        ValueModel? defaultValue;

        if (paramValue.listType == null) {
          defaultValue = delta.newDefaultValue ??
              ObjectUtils.tryGet(
                await calculateDefaultValueUseCase.execute(
                  InputDefaultValueCalculationModel(item: paramValue.unit!),
                ),
              );
        }

        return ConversionParamValueModel(
          param: paramValue.param,
          unit: paramValue.unit,
          calculated: paramValue.calculated,
          value: delta.newValue,
          defaultValue: defaultValue,
          listValues: paramValue.listValues,
        );
      },
    );

    return await _recalculateOtherParams(params: modifiedParams, delta: delta);
  }

  Future<ConversionParamSetValueBulkModel> _recalculateOtherParams({
    required ConversionParamSetValueBulkModel params,
    required EditConversionParamValueDelta delta,
  }) async {
    ConversionParamSetValueModel modifiedParamSetValue =
        params.getParamSetValueById(delta.paramSetId);

    for (var paramValue in modifiedParamSetValue.paramValues) {
      if (paramValue.param.id == delta.paramId || paramValue.listType == null) {
        continue;
      }

      final modifiedParamValue = ObjectUtils.tryGet(
        await initParamListValuesUseCase.execute(
          InputParamListValuesInitModel(
            paramValue: paramValue,
            paramSetValue: modifiedParamSetValue,
          ),
        ),
      );

      modifiedParamSetValue =
          await modifiedParamSetValue.copyWithChangedParamById(
        paramId: paramValue.param.id,
        map: (paramValue, paramSetValue) async => modifiedParamValue,
      );
    }

    return await params.copyWithChangedParamSetById(
      paramSetId: delta.paramSetId,
      map: (paramSetValue) async => modifiedParamSetValue,
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
      await calculateSourceItemByParamsUseCase.execute(
        InputSourceItemByParamsModel(
          oldSourceUnitValue: oldSourceUnitValue,
          unitGroup: unitGroup,
          params: activeParams,
        ),
      ),
    );
  }
}
