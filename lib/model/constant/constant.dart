enum ItemModelType {
  unit,
  unitGroup,
}

enum ItemViewMode {
  list,
  grid;

  ItemViewMode nextValue() {
    int currentValueIndex = ItemViewMode.values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % ItemViewMode.values.length;
    return ItemViewMode.values[nextValueIndex];
  }
}