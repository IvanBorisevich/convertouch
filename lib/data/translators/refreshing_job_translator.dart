import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

class RefreshingJobTranslator
    extends Translator<RefreshingJobModel, RefreshingJobEntity> {
  static final RefreshingJobTranslator I =
      di.locator.get<RefreshingJobTranslator>();

  @override
  RefreshingJobEntity fromModel(RefreshingJobModel model) {
    return RefreshingJobEntity(
      id: model.id!,
      name: model.name,
      unitGroupId: model.unitGroup!.id!,
      refreshableDataPartNum: model.refreshableDataPart.val,
      lastRefreshTime: model.lastRefreshTime,
      cronId: model.cronId,
    );
  }

  @override
  RefreshingJobModel toModel(
    RefreshingJobEntity entity, {
    UnitGroupEntity? unitGroupEntity,
  }) {
    return RefreshingJobModel(
      id: entity.id,
      name: entity.name,
      unitGroup: UnitGroupTranslator.I.toModel(unitGroupEntity),
      refreshableDataPart:
          RefreshableDataPart.values[entity.refreshableDataPartNum],
      lastRefreshTime: entity.lastRefreshTime,
      cronId: entity.cronId,
    );
  }
}
