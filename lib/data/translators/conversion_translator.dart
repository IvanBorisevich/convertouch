import 'package:collection/collection.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:convertouch/data/translators/conversion_item_translator.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class ConversionTranslator
    extends Translator<ConversionModel?, ConversionEntity?> {
  static final ConversionTranslator I = di.locator.get<ConversionTranslator>();

  @override
  ConversionEntity? fromModel(ConversionModel? model) {
    if (model == null) {
      return null;
    }
    return ConversionEntity(
      id: model.id,
      unitGroupId: model.unitGroup.id,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  ConversionModel? toModel(
    ConversionEntity? entity, {
    UnitGroupModel? unitGroup,
    ConversionItemEntity? sourceItemEntity,
    List<ConversionItemEntity> conversionItemEntities = const [],
    List<UnitModel> conversionItemUnits = const [],
  }) {
    if (entity == null) {
      return null;
    }

    Map<int, UnitModel> conversionItemUnitsMap = {
      for (var unit in conversionItemUnits) unit.id: unit
    };

    return ConversionModel(
      id: entity.id ?? -1,
      unitGroup: unitGroup ?? UnitGroupModel.none,
      sourceConversionItem:
          ConversionItemTranslator.I.toModel(sourceItemEntity),
      targetConversionItems: conversionItemEntities
          .map(
            (entity) => ConversionItemTranslator.I.toModel(
              entity,
              unit: conversionItemUnitsMap[entity.unitId],
            ),
          )
          .whereNotNull()
          .toList(),
    );
  }
}
