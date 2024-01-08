import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_units.dart';

const refreshingJobVersions = [
  jobsV1,
];

const jobsV1 = {
  currencyGroup: {
    "name": "Currency Rates",
    "refreshableDataPart": RefreshableDataPart.coefficient,
    "cronName": Cron.everyDay,
    "dataSources": [
      {
        "name": "FloatRates",
        "url": "https://www.floatrates.com/daily/usd.json",
        "responseTransformerClassName": "FloatRatesResponseTransformer",
      },
    ],
  },
  temperatureGroup: {
    "name": "Temperature",
    "refreshableDataPart": RefreshableDataPart.value,
    "cronName": Cron.everyHour,
    "dataSources": [],
  }
};

const cronVersions = [
  cronV1,
];

const cronV1 = [
  {
    'name': 'Every day at 12:00 PM',
    'expression': '0 0 12 1/1 * ? *',
  },
  {
    'name': 'Every hour',
    'expression': '0 0 0/1 1/1 * ? *',
  },
];
