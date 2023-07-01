enum ItemsMenuView {
  list(modeKey: 'listViewMode'),
  grid(modeKey: 'gridViewMode');

  final String modeKey;

  const ItemsMenuView({required this.modeKey});

  ItemsMenuView nextValue() {
    int currentValueIndex = values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % values.length;
    return values[nextValueIndex];
  }
}
