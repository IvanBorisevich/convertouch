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
      code: model.code,
      symbol: model.symbol,
      coefficient: model.coefficient,
      unitGroupId: model.unitGroupId,
      oob: model.oob == true ? 1 : null,
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
      code: entity.code,
      symbol: entity.symbol,
      coefficient: entity.coefficient,
      unitGroupId: entity.unitGroupId,
      oob: entity.oob == 1,
    );
  }
}
