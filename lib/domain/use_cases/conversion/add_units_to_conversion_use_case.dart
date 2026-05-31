import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;
  final CalculateUnitValueUseValue calculateUnitValueUseValue;

  const AddUnitsToConversionUseCase({
    required this.unitRepository,
    required this.calculateUnitValueUseValue,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required AddUnitsToConversionDelta delta,
  }) async {
    List<int> newUnitIds = delta.unitIds
        .whereNot((id) => oldConvertedUnitValues.keys.contains(id))
        .toList();

    final newUnits = ObjectUtils.tryGet(
      await unitRepository.getByIds(newUnitIds),
    );

    List<ConversionUnitValueModel> newUnitValues = [];

    for (var unit in newUnits) {
      var newUnitValue = ObjectUtils.tryGet(
        await calculateUnitValueUseValue.execute(
          InputUnitValueCalculationModel(
            unitValue: ConversionUnitValueModel(
              unit: unit,
            ),
            paramSetValue: params,
            alignCurrentValue: false,
          ),
        ),
      );

      newUnitValues.add(newUnitValue);
    }

    final newConversionItemsMap = {
      for (var unitValue in newUnitValues) unitValue.unit.id: unitValue
    };

    return {
      ...oldConvertedUnitValues,
      ...newConversionItemsMap,
    };
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required AddUnitsToConversionDelta delta,
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
