import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';

class ConvertouchBottomNavigationBar extends StatelessWidget {
  static const _navBarIcons = {
    BottomNavbarItem.home: Icons.home_outlined,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_outlined,
    BottomNavbarItem.refreshableData: Icons.refresh_outlined,
  };

  static const _navBarIconsSelected = {
    BottomNavbarItem.home: Icons.home_rounded,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_rounded,
    BottomNavbarItem.refreshableData: Icons.refresh_rounded,
  };

  static const _navBarLabels = {
    BottomNavbarItem.home: "Home",
    BottomNavbarItem.unitsMenu: "Units Menu",
    BottomNavbarItem.refreshableData: "Refresh Data",
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
      ConvertouchScaffoldColor color = scaffoldColors[appState.theme]!;

      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavbarItem(BottomNavbarItem.home),
          _buildNavbarItem(BottomNavbarItem.unitsMenu),
          _buildNavbarItem(BottomNavbarItem.refreshableData)
        ],
        onTap: (index) {
          onItemSelect?.call(BottomNavbarItem.values[index]);
        },
        currentIndex: selectedItem.index,
        elevation: 0,
        backgroundColor: color.regular.appBarColor,
        unselectedItemColor: color.regular.appBarFontColor,
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
