import 'package:flutter/material.dart';

class ConvertouchNavigationAnimation {
  static Route<dynamic>? wrapIntoAnimation(
    Widget route,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => route,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: anim,
              curve: Curves.easeOutCirc,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: anim,
                curve: Curves.linear,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
