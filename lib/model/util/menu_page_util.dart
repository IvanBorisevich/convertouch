enum ItemsMenuViewMode {
  list(modeKey: 'listViewMode'),
  grid(modeKey: 'gridViewMode');

  final String modeKey;

  const ItemsMenuViewMode({required this.modeKey});

  ItemsMenuViewMode nextValue() {
    int currentValueIndex = values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % values.length;
    return values[nextValueIndex];
  }
}
