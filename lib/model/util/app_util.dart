import 'package:convertouch/model/constant.dart';

String getHomePageId() {
  return unitGroupsPageId;
}

String getPageTitle(String pageId) {
  return pageTitles[pageId] ?? appName;
}

String getSearchBarPlaceholder(String pageId) {
  return searchBarPlaceholders[pageId] ?? "";
}

bool isSearchBarVisible(String pageId) {
  return [unitsPageId, unitGroupsPageId].contains(pageId);
}

bool isFloatingBarVisible(String pageId) {
  return [unitsPageId, unitGroupsPageId, convertedItemsPageId].contains(pageId);
}

ConvertouchAction getLeftAppBarAction(String pageId) {
  return getHomePageId() == pageId
      ? ConvertouchAction.menu
      : ConvertouchAction.back;
}

ConvertouchAction getRightAppBarAction(String pageId, String prevPageId) {
  if (pageId == unitGroupsPageId && prevPageId == convertedItemsPageId) {
    return ConvertouchAction.select;
  }

  if (pageId == unitsPageId && prevPageId == unitGroupsPageId) {
    return ConvertouchAction.select;
  }

  if ([unitCreationPageId, unitGroupCreationPageId].contains(pageId)) {
    return ConvertouchAction.select;
  }

  return ConvertouchAction.none;
}