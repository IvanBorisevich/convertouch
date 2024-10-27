import 'package:convertouch/data/translators/response_translators/response_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/data_source_model.dart';

const defaultDataSourceName = "default";

const convertouchDataSources = {
  currencyGroup: {
    "floatRates": DataSourceModel(
      name: "floatrates.com",
      url: "https://www.floatrates.com/daily/usd.json",
      responseTransformerClassName: floatRatesTranslator,
      refreshablePart: RefreshableDataPart.coefficient,
    ),
    defaultDataSourceName: DataSourceModel(
      name: "convertouch-dynamic-data-gatherer.onrender.com",
      url:
          "https://convertouch-dynamic-data-gatherer.onrender.com/currency-rates/",
      responseTransformerClassName: defaultCurrencyRatesTranslator,
      refreshablePart: RefreshableDataPart.coefficient,
    ),
  },
};
