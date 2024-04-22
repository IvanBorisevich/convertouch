import 'package:convertouch/domain/utils/response_transformers/exchange_rate_response_transformer.dart';
import 'package:test/test.dart';

const String jsonResponseStr = '''
{
 "result":"success",
 "documentation":"https://www.exchangerate-api.com/docs",
 "terms_of_use":"https://www.exchangerate-api.com/terms",
 "time_last_update_unix":1713657602,
 "time_last_update_utc":"Sun, 21 Apr 2024 00:00:02 +0000",
 "time_next_update_unix":1713744002,
 "time_next_update_utc":"Mon, 22 Apr 2024 00:00:02 +0000",
 "base_code":"USD",
 "conversion_rates":{
    "USD":1,
    "AED":3.6725,
    "AFN":71.9438
 }
}
''';

const Map<String, double?> expectedResult = {
  "USD": 1,
  "AED": 1 / 3.6725,
  "AFN": 1 / 71.9438,
};

void main() {
  test(
    'ExchangeRate API response transformation',
    () {
      ExchangeRateResponseTransformer transformer =
          ExchangeRateResponseTransformer();

      Map<String, double?> result = transformer.transform(jsonResponseStr);
      expect(result, expectedResult);
    },
  );
}
