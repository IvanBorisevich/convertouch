import 'package:flutter/cupertino.dart';

class ConvertouchAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final bool visible;

  const ConvertouchAnimatedSwitcher({
    required this.child,
    required this.visible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.decelerate,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Visibility(
        key: ValueKey<bool>(visible),
        visible: visible,
        child: child,
      ),
    );
  }
}
