import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_param_set_model.dart';

class ConversionParamSetTranslator
    extends Translator<ConversionParamSetModel?, ConversionParamSetEntity?> {
  static final ConversionParamSetTranslator I =
      di.locator.get<ConversionParamSetTranslator>();

  @override
  ConversionParamSetEntity? fromModel(ConversionParamSetModel? model) {
    if (model == null) {
      return null;
    }

    return ConversionParamSetEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      mandatory: model.mandatory,
      groupId: model.groupId,
    );
  }

  @override
  ConversionParamSetModel? toModel(ConversionParamSetEntity? entity) {
    if (entity == null) {
      return null;
    }

    return ConversionParamSetModel(
      id: entity.id ?? -1,
      name: entity.name,
      mandatory: entity.mandatory,
      groupId: entity.groupId,
    );
  }
}
