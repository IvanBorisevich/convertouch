import 'package:convertouch/data/translators/response_translators/response_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';

const convertouchDataSources = {
  currencyGroup: {
    "selectedDataSource": "default",
    "refreshablePart": RefreshableDataPart.coefficient,
    "dataSources": {
      "floatRates": {
        "name": "FloatRates",
        "url": "https://www.floatrates.com/daily/usd.json",
        "responseTransformerClassName": floatRatesTranslator,
      },
      "default": {
        "name": "default",
        "url":
            "https://convertouch-dynamic-data-gatherer.onrender.com/currency-rates/",
        "responseTransformerClassName": defaultCurrencyRatesTranslator,
      },
    },
  }
};
