import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:flutter/material.dart';

class ConvertouchFloatingActionButton extends StatelessWidget {
  static const double buttonHeight = 70;

  final IconData icon;
  final void Function()? onClick;
  final bool visible;
  final bool extraLabelVisible;
  final String extraLabelText;
  final BaseColorSet colorSet;

  const ConvertouchFloatingActionButton({
    required this.icon,
    this.onClick,
    this.visible = true,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorSet,
    super.key,
  });

  const ConvertouchFloatingActionButton.adding({
    this.icon = Icons.add,
    this.onClick,
    this.visible = true,
    this.extraLabelVisible = false,
    this.extraLabelText = "",
    required this.colorSet,
    super.key,
  });

  const ConvertouchFloatingActionButton.removal({
    this.icon = Icons.delete_outline_rounded,
    this.onClick,
    this.visible = true,
    this.extraLabelVisible = true,
    required this.extraLabelText,
    required this.colorSet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: SizedBox(
        height: buttonHeight,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            FittedBox(
              child: FloatingActionButton(
                onPressed: onClick,
                backgroundColor: colorSet.background,
                foregroundColor: colorSet.foreground,
                disabledElevation: 0,
                elevation: 0,
                child: Icon(
                  icon,
                  color: colorSet.foreground,
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
                        color: colorSet.background,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: colorSet.border,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Text(
                        extraLabelText,
                        style: TextStyle(
                          color: colorSet.foreground,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : empty(),
          ],
        ),
      ),
    );
  }
}
