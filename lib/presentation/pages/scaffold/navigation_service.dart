import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService I = di.locator.get<NavigationService>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void navigateBack() {
    navigatorKey.currentState?.pop();
  }

  void navigateToStartPage(String startPageName) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      startPageName,
      (route) => false,
    );
  }

  void navigateToHome() {
    navigateToStartPage(homePageId);
  }

  bool isStartPage(BuildContext context) {
    return !(ModalRoute.of(context)?.canPop ?? false);
  }
}
