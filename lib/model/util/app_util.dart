import 'package:convertouch/model/constant.dart';

String getPageTitle(String pageId) {
  return pageTitles[pageId] ?? appName;
}

String getSearchBarPlaceholder(String pageId) {
  return searchBarPlaceholders[pageId] ?? "";
}