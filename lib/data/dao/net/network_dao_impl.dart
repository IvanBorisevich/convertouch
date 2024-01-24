import 'dart:convert';

import 'package:convertouch/data/dao/network_dao.dart';

class NetworkDaoImpl extends NetworkDao {
  const NetworkDaoImpl();

  @override
  Future<String> fetch(String url) async {
    return json.encode({
      "eur": {
        "code": "EUR",
        "alphaCode": "EUR",
        "numericCode": "978",
        "name": "Euro",
        "rate": 0.9177366663222,
        "date": "Mon, 22 Jan 2024 11:55:01 GMT",
        "inverseRate": 1.0896371875469,
      }
    });
  }
}
