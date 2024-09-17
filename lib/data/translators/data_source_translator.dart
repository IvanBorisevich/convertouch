import 'package:convertouch/data/translators/translator.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/data_source_model.dart';

class DataSourceTranslator
    extends Translator<DataSourceModel?, Map<String, dynamic>?> {
  static final DataSourceTranslator I = di.locator.get<DataSourceTranslator>();

  @override
  Map<String, dynamic>? fromModel(DataSourceModel? model) {
    return model?.toJson();
  }

  @override
  DataSourceModel? toModel(Map<String, dynamic>? entity) {
    return DataSourceModel.fromJson(entity);
  }
}
