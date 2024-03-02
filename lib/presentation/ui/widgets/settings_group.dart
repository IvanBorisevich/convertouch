import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingsGroup extends StatelessWidget {
  final String name;
  final List<Widget> items;
  final bool disabled;
  final void Function()? onHeaderTap;
  final ConvertouchUITheme theme;

  const ConvertouchSettingsGroup({
    required this.name,
    this.items = const [],
    this.disabled = false,
    this.onHeaderTap,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingItemColorScheme colorScheme = settingItemColors[theme]!;
    Color foregroundColor;
    Color backgroundColor;
    Color borderColor;

    if (disabled) {
      foregroundColor = colorScheme.foreground.disabled;
      backgroundColor = colorScheme.background.disabled;
      borderColor = colorScheme.border.disabled;
    } else {
      foregroundColor = colorScheme.foreground.regular;
      backgroundColor = colorScheme.background.regular;
      borderColor = colorScheme.border.regular;
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        top: 5,
        right: 5,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: quicksandFontFamily,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
            border: Border.all(
              width: 0.0,
              color: borderColor,
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onHeaderTap?.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ...items,
            ],
          ),
        ),
      ),
    );
  }
}
