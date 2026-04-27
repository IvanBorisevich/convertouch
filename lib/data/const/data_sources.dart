import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';

const apiHost = "convertouch-dynamic-data-gatherer.onrender.com";

const Map<String, Map<String, MainDataSourceEntity>> mainDataSources = {
  GroupNames.currency: {
    ParamSetNames.exchangeRate: MainDataSourceEntity(
      path: "/currency-rates",
      dynamicDataType: DynamicDataType.exchangeRate,
    ),
  },
};

const Map<ConvertouchListType, ListValuesDataSourceEntity> listValuesSources = {
  ConvertouchListType.exchangeRateSource: ListValuesDataSourceEntity(
    path: "/currency-rates/sources",
    listType: ConvertouchListType.exchangeRateSource,
  ),
  ConvertouchListType.exchangeRateBank: ListValuesDataSourceEntity(
    path: "/currency-rates/banks",
    listType: ConvertouchListType.exchangeRateBank,
  ),
};
