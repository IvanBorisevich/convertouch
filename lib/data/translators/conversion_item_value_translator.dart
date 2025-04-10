import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

abstract class ConversionItemValueTranslator<M extends ConversionItemValueModel,
    E extends ConversionItemValueEntity> extends Translator<M, E> {}

class ConversionUnitValueTranslator extends ConversionItemValueTranslator<
    ConversionUnitValueModel, ConversionUnitValueEntity> {
  static final ConversionUnitValueTranslator I =
      di.locator.get<ConversionUnitValueTranslator>();

  @override
  ConversionUnitValueEntity fromModel(
    ConversionUnitValueModel model, {
    int? sequenceNum,
    int? conversionId,
  }) {
    return ConversionUnitValueEntity(
      unitId: model.unit.id,
      value: model.value.isNotEmpty ? model.value.raw : null,
      defaultValue:
          model.defaultValue.isNotEmpty ? model.defaultValue.raw : null,
      sequenceNum: sequenceNum ?? 0,
      conversionId: conversionId!,
    );
  }

  @override
  ConversionUnitValueModel toModel(
    ConversionUnitValueEntity entity, {
    UnitModel? unit,
  }) {
    ValueModel value = ValueModel.str(entity.value);
    ValueModel defaultValue = ValueModel.str(entity.defaultValue);

    return ConversionUnitValueModel(
      unit: unit!,
      value: value,
      defaultValue: defaultValue,
    );
  }
}

class ConversionParamValueTranslator extends ConversionItemValueTranslator<
    ConversionParamValueModel, ConversionParamValueEntity> {
  static final ConversionParamValueTranslator I =
      di.locator.get<ConversionParamValueTranslator>();

  @override
  ConversionParamValueEntity fromModel(
    ConversionParamValueModel model, {
    int? sequenceNum,
    int? conversionId,
  }) {
    return ConversionParamValueEntity(
      paramId: model.param.id,
      unitId: model.unit?.id,
      calculated: model.calculated ? 1 : null,
      value: model.value.isNotEmpty ? model.value.raw : null,
      defaultValue:
          model.defaultValue.isNotEmpty ? model.defaultValue.raw : null,
      sequenceNum: sequenceNum ?? 0,
      conversionId: conversionId!,
    );
  }

  @override
  ConversionParamValueModel toModel(
    ConversionParamValueEntity entity, {
    UnitModel? unit,
    ConversionParamModel? param,
  }) {
    ValueModel value = ValueModel.str(entity.value);
    ValueModel defaultValue = ValueModel.str(entity.defaultValue);

    return ConversionParamValueModel(
      param: param!,
      unit: unit,
      calculated: entity.calculated == 1,
      value: value,
      defaultValue: defaultValue,
    );
  }
}
