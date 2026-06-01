import 'package:convertouch/data/const/constants.dart';
import 'package:convertouch/data/dao/net/network_helper/network_helper.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
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
    await _checkConnection();

    final uri = Uri.https(apiHost, urlPath, queryParams);
    final http.Response response =
        await http.get(uri, headers: headers).catchError(
      (err, stackTrace) {
        throw NetworkException(
          message: "Data fetching failed",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
          severity: ExceptionSeverity.warning,
        );
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw NetworkException(
        message: "HTTP ${response.statusCode} | ${response.reasonPhrase}",
        stackTrace: null,
        dateTime: DateTime.now(),
        severity: ExceptionSeverity.warning,
      );
    }
  }

  Future<void> _checkConnection() async {
    bool isConnected = await networkHelper.isConnected();

    if (!isConnected) {
      throw NetworkException(
        message: "No internet connection",
        severity: ExceptionSeverity.warning,
        stackTrace: null,
        dateTime: DateTime.now(),
        handlingAction: ConvertouchSysAction.connection,
      );
    }
  }
}
