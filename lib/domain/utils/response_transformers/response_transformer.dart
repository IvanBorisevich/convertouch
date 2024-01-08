abstract class ResponseTransformer<T> {
  T transform(String jsonResponse);
}