import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/job_data_source_model.dart';

class JobDataSourceTranslator
    extends Translator<JobDataSourceModel?, JobDataSourceEntity?> {
  static final JobDataSourceTranslator I =
      di.locator.get<JobDataSourceTranslator>();

  @override
  JobDataSourceEntity? fromModel(JobDataSourceModel? model) {
    if (model == null) {
      return null;
    }
    return JobDataSourceEntity(
      id: model.id,
      name: model.name,
      url: model.url,
      responseTransformerClassName: model.responseTransformerClassName,
      jobId: model.jobId,
    );
  }

  @override
  JobDataSourceModel? toModel(JobDataSourceEntity? entity) {
    if (entity == null) {
      return null;
    }
    return JobDataSourceModel(
      id: entity.id,
      name: entity.name,
      url: entity.url,
      responseTransformerClassName: entity.responseTransformerClassName,
      jobId: entity.jobId,
    );
  }
}
