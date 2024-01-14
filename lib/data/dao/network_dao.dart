abstract class NetworkDao {
  const NetworkDao();

  Stream<Object> fetch(String url);
}