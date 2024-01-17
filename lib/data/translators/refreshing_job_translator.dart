import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/job_data_source_translator.dart';
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
      cronName: model.cron != Cron.never ? model.cron.name : null,
      selectedDataSourceId: model.selectedDataSource?.id,
    );
  }

  @override
  RefreshingJobModel toModel(
    RefreshingJobEntity entity, {
    UnitGroupEntity? unitGroupEntity,
        JobDataSourceEntity? selectedDataSource,
  }) {
    return RefreshingJobModel(
      id: entity.id,
      name: entity.name,
      unitGroup: UnitGroupTranslator.I.toModel(unitGroupEntity),
      refreshableDataPart:
          RefreshableDataPart.valueOf(entity.refreshableDataPartNum),
      lastRefreshTime: entity.lastRefreshTime,
      cron: Cron.valueOf(entity.cronName),
      selectedDataSource: JobDataSourceTranslator.I.toModel(selectedDataSource),
    );
  }
}
