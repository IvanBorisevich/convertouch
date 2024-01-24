abstract class NetworkDao {
  const NetworkDao();

  Future<String> fetch(String url);
}