import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  const ReplaceConversionItemUnitUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> modifyConversionUnitValues({
    required Map<int, ConversionUnitValueModel> conversionItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    return conversionItemsMap.map(
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
  ConversionUnitValueModel? newSourceUnitValue({
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) {
    return modifiedConvertedItemsMap[delta.newUnit.id];
  }
}
