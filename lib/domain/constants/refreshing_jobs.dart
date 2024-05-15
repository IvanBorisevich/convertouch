import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_units.dart';
import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

const refreshingJobsMap = {
  currencyGroup: {
    "name": "Currency Rates",
    "group": currencyGroup,
    "refreshableDataPart": RefreshableDataPart.coefficient,
    "selectedDataSource": "default",
    "dataSources": {
      "FloatRates": {
        "name": "FloatRates",
        "url": "https://www.floatrates.com/daily/usd.json",
        "responseTransformerClassName": floatRatesResponseTransformer,
      },
      "default": {
        "name": "default",
        "url":
            "https://convertouch-dynamic-data-gatherer.onrender.com/currency-rates/",
        "responseTransformerClassName": defaultRatesResponseTransformer,
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
