import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_units.dart';

const refreshingJobs = [
  {
    "id": 1,
    "name": "Currency Rates",
    "unitGroupName": currencyGroup,
    "dataRefreshType": RefreshableDataPart.coefficient,
  },
  {
    "id": 2,
    "name": "Temperature",
    "unitGroupName": temperatureGroup,
    "dataRefreshType": RefreshableDataPart.value,
  }
];