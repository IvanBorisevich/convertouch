abstract class NetworkDao {
  const NetworkDao();

  Future<String> fetch(
    String urlPath, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });
}
