import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingListItem<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? selectedValue;
  final bool disabled;
  final void Function(T) onChange;
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final ConvertouchUITheme theme;

  const ConvertouchSettingListItem({
    required this.title,
    required this.value,
    this.selectedValue,
    this.disabled = false,
    required this.onChange,
    this.height = 52,
    this.horizontalPadding = 9,
    this.verticalPadding = 4,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return GestureDetector(
      onTap: () {
        if (!disabled) {
          onChange.call(value);
        }
      },
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: colors.settingItem.background.regular,
        ),
        child: Row(
          children: [
            _radio(
              colors: colors,
            ),
            Expanded(
              child: Column(
                children: [
                  _title(colors: colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title({
    required SettingsColorScheme colors,
  }) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          title,
          style: TextStyle(
            color: colors.settingItem.foreground.regular,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }

  Widget _radio({
    required SettingsColorScheme colors,
  }) {
    return Radio<T>.adaptive(
      groupValue: selectedValue,
      value: value,
      onChanged: null,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.settingItem.foreground.selected;
        }
        if (states.contains(WidgetState.disabled)) {
          return colors.settingItem.foreground.disabled;
        }
        return colors.settingItem.foreground.regular;
      }),
    );
  }
}
