import 'package:convertouch/data/const/constants.dart';
import 'package:convertouch/data/dao/net/network_helper/network_helper.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/env/env.dart';
import 'package:http/http.dart' as http;

class NetworkDaoImpl extends NetworkDao {
  final NetworkHelper networkHelper;

  const NetworkDaoImpl({
    required this.networkHelper,
  });

  @override
  Future<String> fetch(
    String urlPath, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    if (urlPath == exchangeRateSourcesPath) {
      return await Future.delayed(
        const Duration(seconds: 5),
        () =>
        // throw ConvertouchException(
        //   message: "Data fetching failed",
        //   stackTrace: null,
        //   dateTime: DateTime.now(),
        //   severity: ExceptionSeverity.warning,
        // ),
        // '[]'
            '[{"value":"British Central Bank"},{"value":"Exchange-api.com"},{"value":"test-rates.com"}]',
      );
    }

    if (urlPath == exchangeRatePath) {
      return await Future.delayed(
        const Duration(seconds: 5),
        () =>
        throw ConvertouchException(
          message: "Data fetching failed",
          severity: ExceptionSeverity.warning,
        )
        //'{"EUR": 1.2, "AUD": 0.7, "CAD": 0.75}',
      );
    }

    await _checkConnection();

    final uri = Uri.https(Env.apiHost, urlPath, queryParams);
    final http.Response response =
        await http.get(uri, headers: headers).catchError(
      (err, stackTrace) {
        throw ConvertouchException(
          message: "Data fetching failed",
          stackTrace: stackTrace,
          severity: ExceptionSeverity.warning,
        );
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ConvertouchException(
        message: "HTTP ${response.statusCode} | ${response.reasonPhrase}",
        severity: ExceptionSeverity.warning,
      );
    }
  }

  Future<void> _checkConnection() async {
    bool isConnected = await networkHelper.isConnected();

    if (!isConnected) {
      throw ConvertouchException(
        message: "No internet connection",
        severity: ExceptionSeverity.warning,
        handlingAction: ConvertouchSysAction.connection,
      );
    }
  }
}
