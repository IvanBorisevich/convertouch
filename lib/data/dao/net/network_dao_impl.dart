import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:http/http.dart' as http;

class NetworkDaoImpl extends NetworkDao {
  const NetworkDaoImpl();

  @override
  Future<String> fetch(String url) async {
    final parsedUrl = Uri.parse(url);
    final http.Response response = await http.get(parsedUrl).catchError(
      (err, stackTrace) {
        throw NetworkException(
          message: "Data downloading failed",
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
}
