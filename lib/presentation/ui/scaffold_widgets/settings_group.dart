import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingsGroup extends StatelessWidget {
  final String name;
  final List<Widget> items;
  final bool disabled;
  final ConvertouchUITheme theme;

  const ConvertouchSettingsGroup({
    required this.name,
    required this.items,
    this.disabled = false,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BaseColorSet colorSet = disabled
        ? settingItemColors[theme]!.disabled!
        : settingItemColors[theme]!.regular;

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        top: 5,
        right: 5,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: colorSet.foreground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: quicksandFontFamily,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorSet.background,
            border: Border.all(
              width: 0.0,
              color: Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Container(
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
              ...items,
            ],
          ),
        ),
      ),
    );
  }
}
