import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;

  const AddUnitsToConversionUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
    required this.unitRepository,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> modifyConversionUnitValues({
    required Map<int, ConversionUnitValueModel> conversionItemsMap,
    required AddUnitsToConversionDelta delta,
  }) async {
    List<int> newUnitIds = delta.unitIds
        .whereNot((id) => conversionItemsMap.keys.contains(id))
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
      ...conversionItemsMap,
      ...newConversionItemsMap,
    };
  }
}
