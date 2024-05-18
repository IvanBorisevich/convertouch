import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchItemModeIcon extends StatelessWidget {
  final IconData iconData;
  final bool active;
  final double size;
  final ConvertouchColorScheme colors;
  final EdgeInsets padding;

  const ConvertouchItemModeIcon({
    required this.iconData,
    this.active = false,
    this.size = 15,
    this.colors = ConvertouchColorScheme.none,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  const ConvertouchItemModeIcon.checkbox({
    this.active = false,
    this.size = 11,
    this.colors = ConvertouchColorScheme.none,
    this.padding = EdgeInsets.zero,
    super.key,
  }) : iconData = Icons.check_outlined;

  const ConvertouchItemModeIcon.edit({
    this.size = 8,
    this.colors = ConvertouchColorScheme.none,
    this.padding = EdgeInsets.zero,
    super.key,
  })  : iconData = Icons.edit,
        active = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          border: Border.all(
            color: active ? colors.border.selected : colors.border.regular,
            width: 1,
          ),
          color:
              active ? colors.background.selected : colors.background.regular,
        ),
        child: Icon(
          iconData,
          size: size,
          color:
              active ? colors.foreground.selected : colors.foreground.regular,
        ),
      ),
    );
  }
}
