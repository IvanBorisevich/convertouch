enum MenuView {
  list(modeKey: 'listViewMode'),
  grid(modeKey: 'gridViewMode');

  final String modeKey;

  const MenuView({required this.modeKey});

  MenuView nextValue() {
    int currentValueIndex = MenuView.values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % MenuView.values.length;
    return MenuView.values[nextValueIndex];
  }
}
