import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchFloatingActionButton extends StatelessWidget {
  static const double defaultHeight = 70;

  final IconData icon;
  final void Function()? onClick;
  final bool visible;
  final bool disabled;
  final bool extraLabelVisible;
  final String extraLabelText;
  final WidgetColorScheme colorScheme;

  const ConvertouchFloatingActionButton({
    required this.icon,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  });

  const ConvertouchFloatingActionButton.refresh({
    this.icon = Icons.refresh_rounded,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  });

  const ConvertouchFloatingActionButton.adding({
    this.icon = Icons.add,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorScheme,
    super.key,
  });

  const ConvertouchFloatingActionButton.removal({
    this.icon = Icons.delete_outline_rounded,
    this.onClick,
    this.visible = true,
    this.disabled = false,
    this.extraLabelVisible = true,
    required this.extraLabelText,
    required this.colorScheme,
    super.key,
  });

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
