class StringUtils {
  const StringUtils._();

  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static bool isNotNullOrEmpty(String? str) {
    return !isNullOrEmpty(str);
  }

  static bool isUrl(String str) {
    final uri = Uri.tryParse(str);

    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }
}
