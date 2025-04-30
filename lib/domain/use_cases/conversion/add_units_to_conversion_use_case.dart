import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const AddUnitsToConversionUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
    required this.unitRepository,
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
    required ConversionUnitValueModel? oldSourceUnitValue,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required AddUnitsToConversionDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue =
        oldSourceUnitValue ?? modifiedConvertedItemsMap.values.first;

    if (newSrcUnitValue.unit.listType != null) {
      ValueModel? value = newSrcUnitValue.value ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newSrcUnitValue.unit),
          );

      newSrcUnitValue = ConversionUnitValueModel(
        unit: newSrcUnitValue.unit,
        value: value,
      );
    } else {
      ValueModel? defaultValue = newSrcUnitValue.defaultValue ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newSrcUnitValue.unit),
          );

      newSrcUnitValue = newSrcUnitValue.copyWith(
        defaultValue: defaultValue,
      );
    }

    return newSrcUnitValue;
  }
}
