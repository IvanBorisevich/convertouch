import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_source_item_by_params_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;
  final CalculateSourceItemByParamsUseCase calculateSourceItemByParamsUseCase;

  const AddUnitsToConversionUseCase({
    required this.unitRepository,
    required this.calculateSourceItemByParamsUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required AddUnitsToConversionDelta delta,
  }) async {
    List<int> newUnitIds = delta.unitIds
        .whereNot((id) => oldConvertedUnitValues.keys.contains(id))
        .toList();

    final newUnits = ObjectUtils.tryGet(
      await unitRepository.getByIds(newUnitIds),
    );

    final newConversionItemsMap = {
      for (var unit in newUnits)
        unit.id: ConversionUnitValueModel(
          unit: unit,
        )
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
      await calculateSourceItemByParamsUseCase.execute(
        InputSourceItemByParamsModel(
          oldSourceUnitValue: oldSourceUnitValue,
          unitGroupName: unitGroup.name,
          params: activeParams,
        ),
      ),
    );
  }
}
