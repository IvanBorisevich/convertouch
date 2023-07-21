final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;


int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}

void updateSelectedUnitIds(
    final List<int> highlightedUnitIds,
    int? newSelectedUnitId,
    List<int>? conversionUnitIds) {

  conversionUnitIds = conversionUnitIds ?? [];

  if (newSelectedUnitId != null) {
    if (!highlightedUnitIds.contains(newSelectedUnitId)) {
      highlightedUnitIds.add(newSelectedUnitId);
    } else {
      highlightedUnitIds.removeWhere((unitId) => unitId == newSelectedUnitId);
    }
  }

  List<int> newHighlightedUnitIds =
      (conversionUnitIds + highlightedUnitIds).toSet().toList();

  highlightedUnitIds.clear();
  highlightedUnitIds.addAll(newHighlightedUnitIds);
}
