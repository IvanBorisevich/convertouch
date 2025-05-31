import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/dynamic_value_model.dart';

class DynamicValueTranslator
    extends Translator<DynamicValueModel, DynamicValueEntity> {
  static final DynamicValueTranslator I =
      di.locator.get<DynamicValueTranslator>();

  @override
  DynamicValueEntity fromModel(DynamicValueModel model) {
    return DynamicValueEntity(
      unitId: model.unitId,
      value: model.value,
    );
  }

  @override
  DynamicValueModel toModel(DynamicValueEntity entity) {
    return DynamicValueModel(
      unitId: entity.unitId,
      value: entity.value,
    );
  }
}
