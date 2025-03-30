import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';

class ConversionParamTranslator
    extends Translator<ConversionParamModel, ConversionParamEntity> {
  static final ConversionParamTranslator I =
      di.locator.get<ConversionParamTranslator>();

  @override
  ConversionParamEntity fromModel(ConversionParamModel model) {
    return ConversionParamEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      unitGroupId: model.unitGroupId,
      calculable: model.calculable ? 1 : null,
      valueType: model.valueType.val,
      paramSetId: model.paramSetId,
    );
  }

  @override
  ConversionParamModel toModel(ConversionParamEntity entity) {
    return ConversionParamModel(
      id: entity.id ?? -1,
      name: entity.name,
      calculable: entity.calculable == 1,
      paramSetId: entity.paramSetId,
      unitGroupId: entity.unitGroupId!,
      valueType: ConvertouchValueType.valueOf(entity.valueType)!,
    );
  }
}
