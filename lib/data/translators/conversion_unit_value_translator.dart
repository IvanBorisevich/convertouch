import 'package:convertouch/data/entities/conversion_unit_value_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/value_model_utils.dart';

class ConversionUnitValueTranslator
    extends Translator<ConversionUnitValueModel?, ConversionUnitValueEntity?> {
  static final ConversionUnitValueTranslator I =
      di.locator.get<ConversionUnitValueTranslator>();

  @override
  ConversionUnitValueEntity? fromModel(
    ConversionUnitValueModel? model, {
    int? sequenceNum,
    int? conversionId,
  }) {
    if (model == null) {
      return null;
    }
    return ConversionUnitValueEntity(
      unitId: model.unit.id,
      value: model.value.exists ? model.value.raw : null,
      defaultValue: model.defaultValue.exists ? model.defaultValue.raw : null,
      sequenceNum: sequenceNum ?? 0,
      conversionId: conversionId ?? model.unit.unitGroupId,
    );
  }

  @override
  ConversionUnitValueModel? toModel(
    ConversionUnitValueEntity? entity, {
    UnitModel? unit,
  }) {
    if (entity == null || unit == null) {
      return null;
    }

    ValueModel value = ValueModelUtils.ofType(entity.value, unit.valueType);
    ValueModel defaultValue = ValueModelUtils.ofType(
      entity.defaultValue,
      unit.valueType,
    );

    return ConversionUnitValueModel(
      unit: unit,
      value: value,
      defaultValue: defaultValue,
    );
  }
}
