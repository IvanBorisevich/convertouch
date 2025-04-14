import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  const ReplaceConversionItemUnitUseCase({
    required super.createConversionUseCase,
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
              ConversionUnitValueModel.coalesce(
                value,
                unit: delta.newUnit,
              ),
            )
          : MapEntry(key, value),
    );
  }

  @override
  ConversionUnitValueModel modifySourceItem({
    required ConversionUnitValueModel? currentSourceItem,
    required Map<int, ConversionUnitValueModel> modifiedConversionItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) {
    return modifiedConversionItemsMap[delta.newUnit.id]!;
  }
}
