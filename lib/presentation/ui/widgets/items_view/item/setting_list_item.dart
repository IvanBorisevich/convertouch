import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingListItem<T> extends StatelessWidget {
  static const double horizontalPadding = 9;

  final String title;
  final T value;
  final T? selectedValue;
  final bool disabled;
  final void Function(T) onChange;
  final ConvertouchUITheme theme;

  const ConvertouchSettingListItem({
    required this.title,
    required this.value,
    this.selectedValue,
    this.disabled = false,
    required this.onChange,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
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
    );
  }

  Widget _title({
    required SettingsColorScheme colors,
  }) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 1),
        child: Text(
          title,
          style: TextStyle(
            color: colors.settingItem.foreground.regular,
            fontSize: 17,
            fontWeight: FontWeight.w500,
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
      onChanged: (T? newValue) {
        if (!disabled && newValue != null) {
          onChange.call(newValue);
        }
      },
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
