import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_model.dart';

class ConversionTranslator
    extends Translator<ConversionModel, ConversionEntity> {
  static final ConversionTranslator I = di.locator.get<ConversionTranslator>();

  @override
  ConversionEntity fromModel(ConversionModel model) {
    return ConversionEntity(
      id: model.id != -1 ? model.id : null,
      unitGroupId: model.unitGroup.id,
      sourceUnitId: model.srcUnitValue?.unit.id != -1
          ? model.srcUnitValue?.unit.id
          : null,
      sourceValue: model.srcUnitValue?.value?.raw,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  ConversionModel toModel(ConversionEntity entity) {
    return ConversionModel(
      id: entity.id ?? -1,
    );
  }
}
