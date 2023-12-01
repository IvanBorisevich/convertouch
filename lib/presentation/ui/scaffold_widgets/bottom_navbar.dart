import 'package:convertouch/domain/constants/constants.dart';
import 'package:flutter/material.dart';

class ConvertouchBottomNavigationBar extends StatelessWidget {
  static const _navBarIcons = {
    BottomNavbarItem.home: Icons.home_outlined,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_outlined,
  };

  static const _navBarIconsSelected = {
    BottomNavbarItem.home: Icons.home_rounded,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_rounded,
  };

  final BottomNavbarItem selectedItem;
  final Function(BottomNavbarItem)? onItemSelect;

  const ConvertouchBottomNavigationBar({
    required this.selectedItem,
    this.onItemSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildNavbarItem(BottomNavbarItem.home),
        _buildNavbarItem(BottomNavbarItem.unitsMenu),
      ],
      onTap: (index) {
        onItemSelect?.call(BottomNavbarItem.values[index]);
      },
      currentIndex: selectedItem.index,
    );
  }

  BottomNavigationBarItem _buildNavbarItem(BottomNavbarItem bottomNavbarItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        bottomNavbarItem == selectedItem
            ? _navBarIconsSelected[bottomNavbarItem]
            : _navBarIcons[bottomNavbarItem],
      ),
      label: bottomNavbarItem.name,
    );
  }
}