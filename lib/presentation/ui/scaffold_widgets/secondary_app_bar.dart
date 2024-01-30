import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _appBarHeight = 56;

  final Widget? child;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final ConvertouchUITheme theme;

  const SecondaryAppBar({
    required this.child,
    this.visible = true,
    this.padding = const EdgeInsets.only(
      left: 7,
      top: 0,
      right: 7,
      bottom: 7,
    ),
    this.color,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConvertouchScaffoldColor scaffoldColor = scaffoldColors[theme]!;

    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? scaffoldColor.regular.appBarColor,
        ),
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);
}
