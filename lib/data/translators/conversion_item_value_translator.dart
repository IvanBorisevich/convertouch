import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:convertouch/data/entities/entity.dart';
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
      value: model.value?.raw,
      defaultValue: model.defaultValue?.raw,
      sequenceNum: sequenceNum ?? 0,
      conversionId: conversionId!,
    );
  }

  @override
  ConversionUnitValueModel toModel(
    ConversionUnitValueEntity entity, {
    UnitModel? unit,
  }) {
    return ConversionUnitValueModel(
      unit: unit!,
      value: ValueModel.any(entity.value),
      defaultValue: ValueModel.any(entity.defaultValue),
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
      paramSetId: model.param.paramSetId,
      unitId: model.unit?.id,
      calculated: bool2int(model.calculated),
      value: model.value?.raw,
      defaultValue: model.defaultValue?.raw,
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
    return ConversionParamValueModel(
      param: param!,
      unit: unit,
      calculated: int2bool(entity.calculated),
      value: ValueModel.any(entity.value),
      defaultValue: ValueModel.any(entity.defaultValue),
    );
  }
}
