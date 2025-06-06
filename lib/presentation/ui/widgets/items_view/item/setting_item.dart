import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

enum SelectedValuePosition {
  bottom,
  right,
}

class ConvertouchSettingItem<T> extends StatelessWidget {
  final String title;
  final T value;
  final String Function(T)? valueMap;
  final bool switched;
  final SelectedValuePosition selectedValuePosition;
  final void Function()? onTap;
  final List<T> possibleValues;
  final bool possibleValuesInDialog;
  final void Function(T)? onSelect;
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final ConvertouchUITheme theme;

  const ConvertouchSettingItem({
    required this.title,
    required this.value,
    this.valueMap,
    this.switched = false,
    this.selectedValuePosition = SelectedValuePosition.bottom,
    this.onTap,
    this.possibleValues = const [],
    this.possibleValuesInDialog = true,
    this.onSelect,
    this.height = 60,
    this.horizontalPadding = 17,
    this.verticalPadding = 7,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    bool isSwitch = T == bool;

    return GestureDetector(
      onTap: () {
        if (possibleValues.isNotEmpty && possibleValuesInDialog) {
          _showRadioDialog(context, colors: colors);
        } else {
          onTap?.call();
        }
      },
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
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
      ),
    );
  }

  Widget _title({
    required SettingsColorScheme colors,
  }) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //   color: Colors.yellow,
        // ),
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

  Widget _selectedValue({
    required SettingsColorScheme colors,
    bool visible = false,
  }) {
    if (!visible) {
      return const SizedBox(height: 3);
    }

    double fontSize =
        selectedValuePosition == SelectedValuePosition.bottom ? 13 : 14;

    return Container(
      height: selectedValuePosition == SelectedValuePosition.bottom ? 23 : null,
      alignment: selectedValuePosition == SelectedValuePosition.bottom
          ? Alignment.centerLeft
          : Alignment.centerRight,
      padding: const EdgeInsets.only(
        left: 1,
      ),
      child: Text(
        valueMap?.call(value) ?? value.toString(),
        style: TextStyle(
          fontSize: fontSize,
          color: colors.selectedValue.regular,
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
      onChanged: null,
    );
  }

  void _showRadioDialog(
    BuildContext context, {
    required SettingsColorScheme colors,
  }) {
    T selectedValue = value;

    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: colors.settingItem.foreground.regular,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: colors.settingItem.background.regular,
              content: ListView.builder(
                shrinkWrap: true,
                itemCount: possibleValues.length,
                itemBuilder: (context, index) {
                  final itemValue = possibleValues[index];
                  return RadioListTile<T>.adaptive(
                    title: Text(
                      valueMap?.call(itemValue) ?? itemValue.toString(),
                      style: TextStyle(
                        color: colors.settingItem.foreground.regular,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return colors.settingItem.foreground.selected;
                      }
                      if (states.contains(WidgetState.disabled)) {
                        return colors.settingItem.foreground.disabled;
                      }
                      return colors.settingItem.foreground.regular;
                    }),
                    value: itemValue,
                    groupValue: selectedValue,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onSelect?.call(newValue);
                        setStateDialog(() {
                          selectedValue = newValue;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: colors.selectedValue.regular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((returnedValue) {});
  }
}
