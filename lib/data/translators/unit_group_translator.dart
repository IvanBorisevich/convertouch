import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitGroupTranslator
    extends Translator<UnitGroupModel, UnitGroupEntity> {
  static final UnitGroupTranslator I = di.locator.get<UnitGroupTranslator>();

  @override
  UnitGroupEntity fromModel(UnitGroupModel model) {
    return UnitGroupEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      iconName: model.iconName,
      conversionType:
          model.conversionType.value != 0 ? model.conversionType.value : null,
      valueType: model.valueType.id,
      minValue: model.minValue.numVal,
      maxValue: model.maxValue.numVal,
      refreshable: bool2int(model.refreshable),
      oob: bool2int(model.oob),
    );
  }

  @override
  UnitGroupModel toModel(UnitGroupEntity entity) {
    return UnitGroupModel(
      id: entity.id ?? -1,
      name: entity.name,
      iconName: entity.iconName,
      conversionType: ConversionType.valueOf(entity.conversionType),
      valueType: ConvertouchValueType.valueOf(entity.valueType)!,
      minValue: ValueModel.numeric(entity.minValue),
      maxValue: ValueModel.numeric(entity.maxValue),
      refreshable: int2bool(entity.refreshable),
      oob: int2bool(entity.oob, ifNull: true),
    );
  }
}
