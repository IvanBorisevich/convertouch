import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/list_type.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionParamTranslator
    extends Translator<ConversionParamModel?, ConversionParamEntity?> {
  static final ConversionParamTranslator I =
      di.locator.get<ConversionParamTranslator>();

  @override
  ConversionParamEntity? fromModel(ConversionParamModel? model) {
    if (model == null) {
      return null;
    }

    return ConversionParamEntity(
      id: model.id != -1 ? model.id : null,
      name: model.name,
      unitGroupId: model.unitGroupId,
      selectedUnitId: model.selectedUnit?.id,
      calculable: model.calculable,
      listType: model.listType?.val,
      paramSetId: model.paramSetId,
    );
  }

  @override
  ConversionParamModel? toModel(
    ConversionParamEntity? entity, {
    UnitModel? selectedUnit,
  }) {
    if (entity == null) {
      return null;
    }

    return ConversionParamModel(
      id: entity.id ?? -1,
      name: entity.name,
      unitGroupId: entity.unitGroupId,
      selectedUnit: selectedUnit,
      calculable: entity.calculable,
      listType: ConvertouchListType.valueOf(entity.listType),
      paramSetId: entity.paramSetId,
    );
  }
}
