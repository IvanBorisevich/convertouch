import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;

  const AddUnitsToConversionUseCase({
    required super.buildNewConversionUseCase,
    required this.unitRepository,
  });

  @override
  Future<Map<int, ConversionItemModel>> modifyConversionItems(
    Map<int, ConversionItemModel> conversionItemsMap,
    AddUnitsToConversionDelta delta,
  ) async {
    final newUnits = ObjectUtils.tryGet(
      await unitRepository.getByIds(delta.unitIds),
    );

    final addedConversionItemsMap = {
      for (var unit in newUnits)
        unit.id: ConversionItemModel.fromUnit(unit: unit)
    };
    return {
      ...conversionItemsMap,
      ...addedConversionItemsMap,
    };
  }
}
