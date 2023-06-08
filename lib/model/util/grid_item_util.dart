RegExp spaceOrEndOfWord = RegExp(r'\s+|$');
const int minWordLengthToWrap = 10;

int getLinesNumForItemNameWrapping(String gridItemName) {
  return gridItemName.indexOf(spaceOrEndOfWord) > minWordLengthToWrap ? 1 : 2;
}
