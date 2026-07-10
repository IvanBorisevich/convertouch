import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class UpdateConversionCoefficientsUseCase
    extends AbstractModifyConversionUseCase<UpdateConversionCoefficientsDelta> {
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const UpdateConversionCoefficientsUseCase({
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required UpdateConversionCoefficientsDelta delta,
  }) async {
    oldConvertedUnitValues.updateAll(
      (key, item) => item.copyWith(
        unit: item.unit.copyWith(
          coefficient: delta.newCoefficients.unitIdToCoefficient[item.unit.id],
        ),
      ),
    );
    return oldConvertedUnitValues;
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required UpdateConversionCoefficientsDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue = oldSourceUnitValue;

    final currentSrcUnit = oldSourceUnitValue.unit;

    if (currentSrcUnit.coefficient == null &&
        delta.newCoefficients.unitIdToCoefficient[currentSrcUnit.id] == null) {
      final fetchedUnitIdsSet =
          delta.newCoefficients.unitIdToCoefficient.keys.toSet();

      int? firstUpdatedUnitId = newConvertedUnitValues.keys
          .firstWhereOrNull((unitId) => fetchedUnitIdsSet.contains(unitId));

      newSrcUnitValue =
          newConvertedUnitValues[firstUpdatedUnitId] ?? oldSourceUnitValue;
    }

    return await ObjectUtils.tryGet(
      await calculateUnitValueUseValue.execute(
        InputUnitValueCalculationModel(
          itemValue: newSrcUnitValue,
          paramSetValue: activeParams,
          conversionGroup: unitGroup,
        ),
      ),
    );
  }
}
