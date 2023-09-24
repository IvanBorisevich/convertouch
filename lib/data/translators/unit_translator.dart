import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/di.dart' as di;

class UnitTranslator extends Translator<UnitModel?, UnitEntity?> {
  static final UnitTranslator I = di.locator.get<UnitTranslator>();

  @override
  UnitEntity? fromModel(UnitModel? model) {
    if (model == null) {
      return null;
    }
    return UnitEntity(
      id: model.id,
      name: model.name,
      abbreviation: model.abbreviation,
      coefficient: model.coefficient,
      unitGroupId: model.unitGroupId,
    );
  }

  @override
  UnitModel? toModel(UnitEntity? entity) {
    if (entity == null) {
      return null;
    }
    return UnitModel(
      id: entity.id,
      name: entity.name,
      abbreviation: entity.abbreviation,
      coefficient: entity.coefficient,
      unitGroupId: entity.unitGroupId,
    );
  }
}
