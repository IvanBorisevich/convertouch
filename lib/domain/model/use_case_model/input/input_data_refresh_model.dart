import 'package:convertouch/domain/model/data_source_model.dart';

abstract class InputDataRefreshModel {
  final DataSourceModel dataSource;

  const InputDataRefreshModel({
    required this.dataSource,
  });
}

class InputDataRefreshForConversionModel extends InputDataRefreshModel {
  final String unitGroupName;

  const InputDataRefreshForConversionModel({
    required this.unitGroupName,
    required super.dataSource,
  });
}
