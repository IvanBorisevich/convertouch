import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchBottomNavigationBar extends StatelessWidget {
  static const _navBarIcons = {
    BottomNavbarItem.home: Icons.home_outlined,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_outlined,
    BottomNavbarItem.settings: Icons.settings_outlined,
  };

  static const _navBarIconsSelected = {
    BottomNavbarItem.home: Icons.home_rounded,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_rounded,
    BottomNavbarItem.settings: Icons.settings_rounded,
  };

  static const _navBarLabels = {
    BottomNavbarItem.home: "Home",
    BottomNavbarItem.unitsMenu: "Units Menu",
    BottomNavbarItem.settings: "Settings",
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
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageCommonColors[appState.theme]!;

      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavbarItem(BottomNavbarItem.home),
          _buildNavbarItem(BottomNavbarItem.unitsMenu),
          _buildNavbarItem(BottomNavbarItem.settings)
        ],
        onTap: (index) {
          onItemSelect?.call(BottomNavbarItem.values[index]);
        },
        currentIndex: selectedItem.index,
        elevation: 0,
        backgroundColor: pageColorScheme.bottomBar.regular.background,
        unselectedItemColor: pageColorScheme.bottomBar.regular.foreground,
        selectedItemColor: pageColorScheme.bottomBar.selected?.foreground,
      );
    });
  }

  BottomNavigationBarItem _buildNavbarItem(BottomNavbarItem bottomNavbarItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        bottomNavbarItem == selectedItem
            ? _navBarIconsSelected[bottomNavbarItem]
            : _navBarIcons[bottomNavbarItem],
      ),
      label: _navBarLabels[bottomNavbarItem],
    );
  }
}
