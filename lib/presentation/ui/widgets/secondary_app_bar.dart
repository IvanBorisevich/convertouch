import 'package:flutter/material.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _appBarHeight = 56;

  final Widget? child;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color color;

  const SecondaryAppBar({
    required this.child,
    this.visible = true,
    this.padding = const EdgeInsets.only(
      left: 7,
      top: 0,
      right: 7,
      bottom: 8,
    ),
    this.color = Colors.transparent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Size get preferredSize =>
      visible ? const Size.fromHeight(_appBarHeight) : Size.zero;
}
