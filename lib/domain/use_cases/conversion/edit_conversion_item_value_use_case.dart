import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const EditConversionItemValueUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required EditConversionItemValueDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue =
        modifiedConvertedItemsMap[delta.unitId]!;

    if (newSrcUnitValue.unit.listType != null) {
      return ConversionUnitValueModel(
        unit: newSrcUnitValue.unit,
        value: ValueModel.any(delta.newValue),
      );
    } else {
      ValueModel? defaultValue = ValueModel.any(delta.newDefaultValue) ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newSrcUnitValue.unit),
          );

      return ConversionUnitValueModel(
        unit: newSrcUnitValue.unit,
        value: ValueModel.any(delta.newValue),
        defaultValue: defaultValue,
      );
    }
  }

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParamsBySrcUnitValue({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required ConversionUnitValueModel srcUnitValue,
    required EditConversionItemValueDelta delta,
  }) async {
    return oldConversionParams;
  }
}
