import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ConversionItemTranslator
    extends Translator<ConversionItemModel?, ConversionItemEntity?> {
  static final ConversionItemTranslator I =
      di.locator.get<ConversionItemTranslator>();

  @override
  ConversionItemEntity? fromModel(
    ConversionItemModel? model, {
    int? sequenceNum,
    int? conversionId,
  }) {
    if (model == null) {
      return null;
    }
    return ConversionItemEntity(
      unitId: model.unit.id,
      value: model.value.exists ? model.value.str : null,
      defaultValue: model.defaultValue.exists ? model.defaultValue.str : null,
      sequenceNum: sequenceNum ?? 0,
      conversionId: conversionId ?? model.unit.unitGroupId,
    );
  }

  @override
  ConversionItemModel? toModel(
    ConversionItemEntity? entity, {
    UnitModel? unit,
  }) {
    if (entity == null || unit == null) {
      return null;
    }

    ValueModel value = ValueModel.ofString(entity.value);
    ValueModel defaultValue = ValueModel.ofString(entity.defaultValue);

    return ConversionItemModel(
      unit: unit,
      value: value.exists ? value : ValueModel.none,
      defaultValue: defaultValue.exists ? defaultValue : ValueModel.one,
    );
  }
}
