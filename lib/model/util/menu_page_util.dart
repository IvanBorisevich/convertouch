final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;


int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}
