import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitTranslator extends Translator<UnitModel, UnitEntity> {
  static final UnitTranslator I = di.locator.get<UnitTranslator>();

  @override
  UnitEntity fromModel(UnitModel model) {
    return UnitEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      code: model.code,
      symbol: model.symbol,
      coefficient: model.coefficient,
      unitGroupId: model.unitGroupId,
      valueType: model.valueType.id,
      listType: model.listType?.id,
      minValue: model.minValue.numVal,
      maxValue: model.maxValue.numVal,
      invertible: bool2int(model.invertible),
      oob: bool2int(model.oob),
    );
  }

  @override
  UnitModel toModel(UnitEntity entity) {
    return UnitModel(
      id: entity.id ?? -1,
      name: entity.name,
      code: entity.code,
      symbol: entity.symbol,
      coefficient: entity.coefficient,
      unitGroupId: entity.unitGroupId,
      valueType: ConvertouchValueType.valueOf(entity.valueType)!,
      listType: ConvertouchListType.valueOf(entity.listType),
      minValue: ValueModel.numeric(entity.minValue),
      maxValue: ValueModel.numeric(entity.maxValue),
      invertible: int2bool(entity.invertible, ifNull: true),
      oob: int2bool(entity.oob, ifNull: true),
    );
  }
}
