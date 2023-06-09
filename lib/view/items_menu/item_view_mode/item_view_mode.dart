import 'package:flutter/material.dart';

enum ItemViewMode {
  list(
      modeKey: ValueKey('listViewMode'),
      nextModeIcon: Icons.grid_view_outlined),
  grid(
      modeKey: ValueKey('gridViewMode'),
      nextModeIcon: Icons.list_outlined);

  final ValueKey<String> modeKey;
  final IconData nextModeIcon;

  const ItemViewMode({required this.modeKey, required this.nextModeIcon});

  ItemViewMode nextValue() {
    int currentValueIndex = ItemViewMode.values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % ItemViewMode.values.length;
    return ItemViewMode.values[nextValueIndex];
  }
}