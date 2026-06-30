class StringUtils {
  const StringUtils._();

  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static bool isNotNullOrEmpty(String? str) {
    return !isNullOrEmpty(str);
  }
}
