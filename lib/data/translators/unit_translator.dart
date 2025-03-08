import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitTranslator extends Translator<UnitModel?, UnitEntity?> {
  static final UnitTranslator I = di.locator.get<UnitTranslator>();

  @override
  UnitEntity? fromModel(UnitModel? model) {
    if (model == null) {
      return null;
    }
    return UnitEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      code: model.code,
      symbol: model.symbol,
      coefficient: model.coefficient,
      unitGroupId: model.unitGroupId,
      valueType: model.valueType.val,
      minValue: model.minValue.num,
      maxValue: model.maxValue.num,
      invertible: model.invertible ? null : 0,
      oob: model.oob == true ? 1 : null,
    );
  }

  @override
  UnitModel? toModel(UnitEntity? entity) {
    if (entity == null) {
      return null;
    }
    return UnitModel(
      id: entity.id ?? -1,
      name: entity.name,
      code: entity.code,
      symbol: entity.symbol,
      coefficient: entity.coefficient,
      unitGroupId: entity.unitGroupId,
      valueType: ConvertouchValueType.valueOf(entity.valueType)!,
      minValue: ValueModel.num(entity.minValue),
      maxValue: ValueModel.num(entity.maxValue),
      invertible: entity.invertible == 0 ? false : true,
      oob: entity.oob == 1,
    );
  }
}
