enum ItemViewMode {
  list(modeKey: 'listViewMode'),
  grid(modeKey: 'gridViewMode');

  final String modeKey;

  const ItemViewMode({required this.modeKey});

  ItemViewMode nextValue() {
    int currentValueIndex = ItemViewMode.values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % ItemViewMode.values.length;
    return ItemViewMode.values[nextValueIndex];
  }
}
