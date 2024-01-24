import 'package:convertouch/data/dao/network_dao.dart';
import 'package:http/http.dart' as http;

class NetworkDaoImpl extends NetworkDao {
  const NetworkDaoImpl();

  @override
  Future<String> fetch(String url) async {
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data from the url = $url');
    }
  }
}
