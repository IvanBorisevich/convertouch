import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/bottom_navbar.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/bottom_navbar_item_navigator.dart';
import 'package:flutter/material.dart';

class ConvertouchScaffold extends StatefulWidget {
  const ConvertouchScaffold({super.key});

  @override
  State createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  var _selectedNavbarItem = BottomNavbarItem.home;

  final _bottomBarNavigatorKeys = {
    BottomNavbarItem.home: GlobalKey<NavigatorState>(),
    BottomNavbarItem.unitsMenu: GlobalKey<NavigatorState>(),
    BottomNavbarItem.refreshableData: GlobalKey<NavigatorState>(),
  };

  void _selectNavbarItem(BottomNavbarItem bottomNavbarItem) {
    if (bottomNavbarItem == _selectedNavbarItem) {
      _bottomBarNavigatorKeys[bottomNavbarItem]!.currentState!.popUntil(
            (route) => route.isFirst,
          );
    } else {
      setState(() => _selectedNavbarItem = bottomNavbarItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInSelectedNavbarItem =
            !await _bottomBarNavigatorKeys[_selectedNavbarItem]!
                .currentState!
                .maybePop();
        if (isFirstRouteInSelectedNavbarItem) {
          if (_selectedNavbarItem != BottomNavbarItem.home) {
            _selectNavbarItem(BottomNavbarItem.home);
            return false;
          }
        }
        return isFirstRouteInSelectedNavbarItem;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              _buildOffstageNavigator(
                  BottomNavbarItem.home, unitsConversionPage),
              _buildOffstageNavigator(
                  BottomNavbarItem.unitsMenu, unitGroupsPageRegular),
              _buildOffstageNavigator(
                  BottomNavbarItem.refreshableData, refreshingJobsPage),
              // _buildOffstageNavigator(BottomNavbarItem.more),
            ],
          ),
          bottomNavigationBar: ConvertouchBottomNavigationBar(
            selectedItem: _selectedNavbarItem,
            onItemSelect: _selectNavbarItem,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(
    BottomNavbarItem bottomNavbarItem,
    String rootPageId,
  ) {
    return Offstage(
      offstage: bottomNavbarItem != _selectedNavbarItem,
      child: ConvertouchBottomNavbarItemNavigator(
        navigatorKey: _bottomBarNavigatorKeys[bottomNavbarItem],
        bottomNavbarItem: bottomNavbarItem,
        rootPageId: rootPageId,
      ),
    );
  }
}
