import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/animation/navigation_animation.dart';
import 'package:flutter/material.dart';

class ConvertouchRootScreen extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<String, Widget> routesMap;
  final BottomNavbarItem bottomNavbarItem;
  final PageName rootPageId;
  final bool selected;

  const ConvertouchRootScreen({
    required this.navigatorKey,
    required this.routesMap,
    required this.bottomNavbarItem,
    required this.rootPageId,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !selected,
      child: Navigator(
        key: navigatorKey,
        initialRoute: rootPageId.name,
        onGenerateRoute: (settings) {
          return ConvertouchNavigationAnimation.wrapIntoAnimation(
            _getRoute(settings.name),
            settings,
          );
        },
      ),
    );
  }

  Widget _getRoute(String? routeName) {
    return routesMap[routeName] ?? routesMap[rootPageId.name]!;
  }
}
