import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/refreshable_value_model.dart';

class RefreshableValueTranslator
    extends Translator<RefreshableValueModel?, RefreshableValueEntity?> {
  static final RefreshableValueTranslator I =
      di.locator.get<RefreshableValueTranslator>();

  @override
  RefreshableValueEntity? fromModel(RefreshableValueModel? model) {
    if (model == null) {
      return null;
    }
    return RefreshableValueEntity(
      unitId: model.unitId,
      value: model.value,
    );
  }

  @override
  RefreshableValueModel? toModel(RefreshableValueEntity? entity) {
    if (entity == null) {
      return null;
    }
    return RefreshableValueModel(
      unitId: entity.unitId,
      value: entity.value,
    );
  }
}
