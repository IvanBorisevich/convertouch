import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  const ReplaceConversionItemUnitUseCase({
    required super.createConversionUseCase,
  });

  @override
  Future<Map<int, ConversionItemModel>> modifyConversionItems({
    required Map<int, ConversionItemModel> conversionItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    return conversionItemsMap.map(
      (key, value) => key == delta.oldUnitId
          ? MapEntry(
              delta.newUnit.id,
              ConversionItemModel.coalesce(
                value,
                unit: delta.newUnit,
              ),
            )
          : MapEntry(key, value),
    );
  }

  @override
  ConversionItemModel getModifiedSourceItem({
    required ConversionItemModel? currentSourceItem,
    required Map<int, ConversionItemModel> modifiedConversionItemsMap,
    required ReplaceConversionItemUnitDelta delta,
  }) {
    return modifiedConversionItemsMap[delta.newUnit.id]!;
  }
}
