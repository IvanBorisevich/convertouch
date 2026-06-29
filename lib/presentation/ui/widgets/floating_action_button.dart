import 'package:convertouch/presentation/ui/animation/animated_switcher_ext.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchFloatingActionButton extends StatelessWidget {
  static const double defaultHeight = 70;

  final IconData icon;
  final double? iconSize;
  final void Function()? onClick;
  final bool visible;
  final bool disabled;
  final String? extraLabelText;
  final WidgetColorScheme colorScheme;

  const ConvertouchFloatingActionButton({
    required this.icon,
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelText,
    required this.colorScheme,
    super.key,
  });

  const ConvertouchFloatingActionButton.refresh({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  }) : icon = Icons.refresh_rounded;

  const ConvertouchFloatingActionButton.failure({
    this.iconSize,
    this.onClick,
    this.visible = true,
    required this.colorScheme,
    super.key,
  })  : icon = Icons.sync_problem_rounded,
        disabled = false,
        extraLabelText = null;

  const ConvertouchFloatingActionButton.adding({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    required this.colorScheme,
    super.key,
  })  : icon = Icons.add,
        extraLabelText = null;

  const ConvertouchFloatingActionButton.removal({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    required this.extraLabelText,
    required this.colorScheme,
    super.key,
  }) : icon = Icons.delete_outline_rounded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: defaultHeight,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FittedBox(
            child: ConvertouchAnimatedSwitcher(
              visible: visible,
              child: extraLabelText != null && extraLabelText!.isNotEmpty
                  ? FloatingActionButton.extended(
                      label: Container(
                        width: 10,
                        alignment: Alignment.center,
                        child: Text(
                          extraLabelText!,
                          style: TextStyle(
                            color: disabled
                                ? colorScheme.foreground.disabled
                                : colorScheme.foreground.regular,
                            letterSpacing: 0,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      icon: Icon(
                        icon,
                        color: disabled
                            ? colorScheme.foreground.disabled
                            : colorScheme.foreground.regular,
                        size: iconSize,
                      ),
                      onPressed: disabled ? null : onClick,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      backgroundColor: disabled
                          ? colorScheme.background.disabled
                          : colorScheme.background.regular,
                      foregroundColor: disabled
                          ? colorScheme.foreground.disabled
                          : colorScheme.foreground.regular,
                      disabledElevation: 0,
                      elevation: 0,
                    )
                  : FloatingActionButton(
                      onPressed: disabled ? null : onClick,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      backgroundColor: disabled
                          ? colorScheme.background.disabled
                          : colorScheme.background.regular,
                      foregroundColor: disabled
                          ? colorScheme.foreground.disabled
                          : colorScheme.foreground.regular,
                      disabledElevation: 0,
                      elevation: 0,
                      child: Icon(
                        icon,
                        color: disabled
                            ? colorScheme.foreground.disabled
                            : colorScheme.foreground.regular,
                        size: iconSize,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
