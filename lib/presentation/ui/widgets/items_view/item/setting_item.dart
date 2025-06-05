import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

enum SelectedValuePosition {
  bottom,
  right,
}

class ConvertouchSettingItem<T> extends StatelessWidget {
  static const double horizontalPadding = 9;

  final String title;
  final T value;
  final String Function(T)? valueMap;
  final bool switched;
  final SelectedValuePosition selectedValuePosition;
  final void Function() onTap;
  final ConvertouchUITheme theme;

  const ConvertouchSettingItem({
    required this.title,
    required this.value,
    this.valueMap,
    this.switched = false,
    this.selectedValuePosition = SelectedValuePosition.right,
    required this.onTap,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    bool isSwitch = T == bool;

    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: colors.settingItem.background.regular,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _title(colors: colors),
                _selectedValue(
                  colors: colors,
                  visible: !isSwitch &&
                      selectedValuePosition == SelectedValuePosition.bottom,
                ),
              ],
            ),
          ),
          _selectedValue(
            colors: colors,
            visible: !isSwitch &&
                selectedValuePosition == SelectedValuePosition.right,
          ),
          _switch(
            colors: colors,
            visible: isSwitch,
            active: switched,
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

  Widget _selectedValue({
    required SettingsColorScheme colors,
    bool visible = false,
  }) {
    if (!visible) {
      return const SizedBox(height: 1);
    }

    double fontSize =
        selectedValuePosition == SelectedValuePosition.right ? 16 : 13;
    double rightPadding = selectedValuePosition == SelectedValuePosition.right
        ? horizontalPadding
        : 0;

    return Container(
      height: selectedValuePosition == SelectedValuePosition.bottom ? 23 : null,
      alignment: selectedValuePosition == SelectedValuePosition.bottom
          ? Alignment.topLeft
          : Alignment.centerRight,
      padding: EdgeInsets.only(
        left: 1,
        right: rightPadding,
      ),
      child: Text(
        valueMap?.call(value) ?? value.toString(),
        style: TextStyle(
          fontSize: fontSize,
          color: colors.selectedValueColor.regular,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _switch({
    required SettingsColorScheme colors,
    bool visible = false,
    bool active = false,
  }) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    return Switch(
      value: active,
      activeColor: colors.settingItem.foreground.selected,
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.settingItem.foreground.disabled;
          }
          return colors.settingItem.foreground.regular;
        },
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.switcher.track.border.selected;
        }
        if (states.contains(WidgetState.disabled)) {
          return colors.switcher.track.border.disabled;
        }
        return colors.switcher.track.border.regular;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.switcher.track.background.selected;
        }
        if (states.contains(WidgetState.disabled)) {
          return colors.switcher.track.background.disabled;
        }
        return colors.switcher.track.background.regular;
      }),
      onChanged: (bool newValue) {
        onTap.call();
      },
    );
  }
}
