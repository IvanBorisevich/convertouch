import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/animation/navigation_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRootScreen extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<String, Widget> routesMap;
  final BottomNavbarItem bottomNavbarItem;
  final PageName rootPageId;
  final bool selected;
  final void Function()? onInit;

  const ConvertouchRootScreen({
    required this.navigatorKey,
    required this.routesMap,
    required this.bottomNavbarItem,
    required this.rootPageId,
    required this.selected,
    this.onInit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listenWhen: (prev, next) {
        return prev != next &&
            next is NavigationDone &&
            next.selectedNavbarItem == bottomNavbarItem &&
            next.selectedNavbarItem != BottomNavbarItem.home;
      },
      listener: (_, state) {
        if (state is NavigationDone &&
            state.selectedNavbarItem == bottomNavbarItem &&
            state.selectedNavbarItem != BottomNavbarItem.home &&
            state.isBottomNavbarOpenedFirstTime) {
          onInit?.call();
        }
      },
      child: Offstage(
        offstage: !selected,
        child: Navigator(
          key: navigatorKey,
          initialRoute: rootPageId.name,
          onGenerateRoute: (settings) {
            return ConvertouchNavigationAnimation.wrapIntoAnimation(
              routesMap[settings.name] ?? routesMap[rootPageId.name]!,
              settings,
            );
          },
        ),
      ),
    );
  }
}
