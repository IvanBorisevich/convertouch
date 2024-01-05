import 'package:convertouch/data/entities/cron_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/cron_model.dart';

class CronTranslator extends Translator<CronModel?, CronEntity?> {
  static final CronTranslator I = di.locator.get<CronTranslator>();

  @override
  CronEntity? fromModel(CronModel? model) {
    if (model == null) {
      return null;
    }
    return CronEntity(
      id: model.id,
      name: model.name,
      expression: model.expression,
    );
  }

  @override
  CronModel? toModel(CronEntity? entity) {
    if (entity == null) {
      return null;
    }
    return CronModel(
      id: entity.id,
      name: entity.name,
      expression: entity.expression,
    );
  }
}
