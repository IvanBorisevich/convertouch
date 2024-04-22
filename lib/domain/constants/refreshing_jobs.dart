import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_units.dart';
import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

const exchangeRateApiKey = "275cf93429c3a96538392e3f";

const refreshingJobsMap = {
  currencyGroup: {
    "name": "Currency Rates",
    "group": currencyGroup,
    "refreshableDataPart": RefreshableDataPart.coefficient,
    "selectedDataSource": "ExchangeRateAPI",
    "dataSources": {
      "FloatRates": {
        "name": "FloatRates",
        "url": "https://www.floatrates.com/daily/usd.json",
        "responseTransformerClassName": floatRatesResponseTransformer,
      },
      "ExchangeRateAPI": {
        "name": "ExchangeRateAPI",
        "url":
            "https://v6.exchangerate-api.com/v6/$exchangeRateApiKey/latest/USD",
        "responseTransformerClassName": exchangeRateResponseTransformer,
      },
    },
  },
  // temperatureGroup: {
  //   "name": "Temperature",
  //   "group": temperatureGroup,
  //   "refreshableDataPart": RefreshableDataPart.value,
  //   "dataSources": {},
  // }
};
