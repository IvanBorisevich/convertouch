import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationService {
  static final NavigationService I = GetIt.I<NavigationService>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(
    String routeName, {
    Object? arguments
  }) {
    return navigatorKey.currentState?.pushNamed(routeName,
        arguments: arguments);
  }

  void navigateBack() {
    navigatorKey.currentState?.pop();
  }

  bool isHomePage(BuildContext context) {
    return !(ModalRoute.of(context)?.canPop ?? false);
  }
}