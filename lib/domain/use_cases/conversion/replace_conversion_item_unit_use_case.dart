import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final ListValueRepository listValueRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const ReplaceConversionItemUnitUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
    required this.listValueRepository,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    return oldConvertedUnitValues.map(
      (key, value) => key == delta.oldUnitId
          ? MapEntry(
              delta.newUnit.id,
              value.copyWith(
                unit: delta.newUnit,
              ),
            )
          : MapEntry(key, value),
    );
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue =
        modifiedConvertedItemsMap[delta.newUnit.id]!;

    if (newSrcUnitValue.unit.listType != null) {
      bool belongsToList = ObjectUtils.tryGet(
        await listValueRepository.belongsToList(
          value: newSrcUnitValue.value?.raw,
          listType: newSrcUnitValue.unit.listType!,
        ),
      );

      ValueModel? value;
      if (belongsToList) {
        value = newSrcUnitValue.value;
      } else {
        value = ObjectUtils.tryGet(
          await calculateDefaultValueUseCase.execute(newSrcUnitValue.unit),
        );
      }

      return ConversionUnitValueModel(
        unit: newSrcUnitValue.unit,
        value: value,
      );
    } else {
      ValueModel? defaultValue = newSrcUnitValue.defaultValue ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newSrcUnitValue.unit),
          );

      return newSrcUnitValue.copyWith(
        defaultValue: defaultValue,
      );
    }
  }
}
