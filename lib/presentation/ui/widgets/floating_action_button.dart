import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchFloatingActionButton extends StatelessWidget {
  static const double defaultHeight = 70;

  final IconData icon;
  final double? iconSize;
  final void Function()? onClick;
  final bool visible;
  final bool disabled;
  final bool extraLabelVisible;
  final String extraLabelText;
  final WidgetColorScheme colorScheme;

  const ConvertouchFloatingActionButton({
    required this.icon,
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  });

  const ConvertouchFloatingActionButton.refresh({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
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
        extraLabelVisible = false,
        extraLabelText = "";

  const ConvertouchFloatingActionButton.adding({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  }) : icon = Icons.add;

  const ConvertouchFloatingActionButton.removal({
    this.iconSize,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = true,
    required this.extraLabelText,
    required this.colorScheme,
    super.key,
  }) : icon = Icons.delete_outline_rounded;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: SizedBox(
        height: defaultHeight,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            FittedBox(
              child: FloatingActionButton(
                onPressed: disabled ? null : onClick,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(
                    color: disabled
                        ? colorScheme.border.disabled
                        : colorScheme.border.regular,
                    width: 1,
                  ),
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
            extraLabelVisible
                ? Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: disabled
                            ? colorScheme.background.disabled
                            : colorScheme.background.regular,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: disabled
                              ? colorScheme.border.disabled
                              : colorScheme.border.regular,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Text(
                        extraLabelText,
                        style: TextStyle(
                          color: disabled
                              ? colorScheme.foreground.disabled
                              : colorScheme.foreground.regular,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
