import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';

const apiHost = "convertouch-dynamic-data-gatherer.onrender.com";

const Map<String, Map<String, DataSourceEntity>> convertouchDataSources = {
  GroupNames.currency: {
    ParamSetNames.exchangeRate: DataSourceEntity(
      path: "/currency-rates",
      dynamicDataType: DynamicDataType.exchangeRate,
    ),
  },
};
