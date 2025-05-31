import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final ReplaceUnitInConversionItemUseCase replaceUnitInConversionItemUseCase;

  const ReplaceConversionItemUnitUseCase({
    required this.replaceUnitInConversionItemUseCase,
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
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue =
        newConvertedUnitValues[delta.newUnit.id]!;

    return ObjectUtils.tryGet(
      await replaceUnitInConversionItemUseCase.execute(
        InputItemUnitReplaceModel(
          item: newSrcUnitValue,
          newUnit: delta.newUnit,
        ),
      ),
    );
  }
}
