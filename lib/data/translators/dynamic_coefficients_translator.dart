import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/dynamic_data_model.dart';

class DynamicCoefficientsTranslator
    extends Translator<DynamicCoefficientsModel, List<UnitEntity>> {
  static final DynamicCoefficientsTranslator I =
      di.locator.get<DynamicCoefficientsTranslator>();

  @override
  List<UnitEntity> fromModel(DynamicCoefficientsModel model) {
    throw UnimplementedError();
  }

  @override
  DynamicCoefficientsModel toModel(List<UnitEntity> entities) {
    Map<int, double?> unitIdToCoefficient = {
      for (var unit in entities) unit.id!: unit.coefficient
    };

    return DynamicCoefficientsModel(unitIdToCoefficient);
  }
}
