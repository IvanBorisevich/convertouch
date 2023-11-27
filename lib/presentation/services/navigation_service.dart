import 'package:convertouch/di.dart' as di;
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService I = di.locator.get<NavigationService>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateBack() {
    navigatorKey.currentState?.pop();
  }
}
