import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class UnitGroupTranslator
    extends Translator<UnitGroupModel?, UnitGroupEntity?> {
  static final UnitGroupTranslator I = di.locator.get<UnitGroupTranslator>();

  @override
  UnitGroupModel? toModel(UnitGroupEntity? entity) {
    if (entity == null) {
      return null;
    }
    return UnitGroupModel(
      id: entity.id!,
      name: entity.name,
      iconName: entity.iconName ?? unitGroupDefaultIconName,
    );
  }

  @override
  UnitGroupEntity? fromModel(UnitGroupModel? model) {
    if (model == null) {
      return null;
    }
    return UnitGroupEntity(
      id: model.id,
      name: model.name,
      iconName:
          model.iconName != unitGroupDefaultIconName ? model.iconName : null,
    );
  }
}
