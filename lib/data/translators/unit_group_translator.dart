import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitGroupTranslator
    extends Translator<UnitGroupModel?, UnitGroupEntity?> {
  static final UnitGroupTranslator I = di.locator.get<UnitGroupTranslator>();

  @override
  UnitGroupEntity? fromModel(UnitGroupModel? model) {
    if (model == null) {
      return null;
    }
    return UnitGroupEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      iconName: model.iconName,
      conversionType:
          model.conversionType.value != 0 ? model.conversionType.value : null,
      refreshable: model.refreshable == true ? 1 : null,
      valueType: model.valueType.val,
      minValue: model.minValue.num,
      maxValue: model.maxValue.num,
      oob: model.oob == true ? 1 : null,
    );
  }

  @override
  UnitGroupModel? toModel(UnitGroupEntity? entity) {
    if (entity == null) {
      return null;
    }
    return UnitGroupModel(
      id: entity.id ?? -1,
      name: entity.name,
      iconName: entity.iconName,
      conversionType: ConversionType.valueOf(entity.conversionType),
      refreshable: entity.refreshable == 1,
      valueType: ConvertouchValueType.valueOf(entity.valueType) ??
          UnitGroupModel.defaultValueType,
      minValue: ValueModel.num(entity.minValue),
      maxValue: ValueModel.num(entity.maxValue),
      oob: entity.oob == 1,
    );
  }
}
