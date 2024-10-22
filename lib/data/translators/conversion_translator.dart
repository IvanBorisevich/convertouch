import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_model.dart';

class ConversionTranslator
    extends Translator<ConversionModel?, ConversionEntity?> {
  static final ConversionTranslator I = di.locator.get<ConversionTranslator>();

  @override
  ConversionEntity? fromModel(ConversionModel? model) {
    if (model == null) {
      return null;
    }
    return ConversionEntity(
      id: model.id != -1 ? model.id : null,
      unitGroupId: model.unitGroup.id,
      sourceUnitId: model.sourceConversionItem?.unit.id != -1
          ? model.sourceConversionItem?.unit.id
          : null,
      sourceValue: model.sourceConversionItem?.value.exists == true
          ? model.sourceConversionItem!.value.str
          : null,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  ConversionModel? toModel(ConversionEntity? entity) {
    if (entity == null) {
      return null;
    }

    return ConversionModel(
      id: entity.id ?? -1,
    );
  }
}
