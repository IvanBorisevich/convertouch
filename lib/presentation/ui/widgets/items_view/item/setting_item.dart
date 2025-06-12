import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/radio_dialog.dart';
import 'package:flutter/material.dart';

enum SubtitlePosition {
  bottom,
  right,
}

const double _itemHeight = 60;
const EdgeInsets _itemPadding = EdgeInsets.only(
  top: 7,
  bottom: 7,
  left: 15,
  right: 10,
);

class ConvertouchSettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final double? titleLineHeight;
  final SubtitlePosition? subtitlePosition;
  final double height;
  final EdgeInsets padding;
  final void Function()? onTap;
  final ConvertouchUITheme theme;

  const ConvertouchSettingItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.titleLineHeight,
    this.subtitlePosition,
    this.height = _itemHeight,
    this.padding = _itemPadding,
    this.onTap,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: colors.settingItem.background.regular,
        ),
        child: Row(
          children: [
            leading ?? const SizedBox.shrink(),
            Expanded(
              child: Column(
                children: [
                  _title(colors),
                  (subtitlePosition == SubtitlePosition.bottom
                          ? _subtitle(colors)
                          : null) ??
                      const SizedBox.shrink(),
                ],
              ),
            ),
            (subtitlePosition == SubtitlePosition.right
                    ? _subtitle(colors)
                    : null) ??
                const SizedBox.shrink(),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _title(SettingsColorScheme colors) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: colors.settingItem.foreground.regular,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            height: titleLineHeight,
          ),
        ),
      ),
    );
  }

  Widget? _subtitle(SettingsColorScheme colors) {
    if (subtitle == null) {
      return null;
    }

    double fontSize = subtitlePosition == SubtitlePosition.bottom ? 13 : 14;

    return Container(
      height: subtitlePosition == SubtitlePosition.bottom ? 23 : null,
      alignment: subtitlePosition == SubtitlePosition.bottom
          ? Alignment.centerLeft
          : Alignment.centerRight,
      padding: const EdgeInsets.only(
        left: 1,
      ),
      child: Text(
        subtitle!,
        style: TextStyle(
          fontSize: fontSize,
          color: colors.selectedValue.regular,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SwitcherSettingItem extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onSwitch;
  final ConvertouchUITheme theme;

  const SwitcherSettingItem({
    required this.title,
    required this.value,
    this.onSwitch,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return ConvertouchSettingItem(
      title: title,
      titleLineHeight: 1.1,
      trailing: _switch(
        colors: colors,
        active: value,
      ),
      onTap: () {
        onSwitch?.call(!value);
      },
      theme: theme,
    );
  }

  Widget _switch({
    required SettingsColorScheme colors,
    bool active = false,
  }) {
    return Switch.adaptive(
      value: active,
      activeColor: colors.settingItem.foreground.selected,
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          return colors.settingItem.foreground.regular;
        },
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.switcher.track.border.selected;
        }
        return colors.switcher.track.border.regular;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.switcher.track.background.selected;
        }
        return Colors.transparent;
      }),
      onChanged: null,
    );
  }
}

class SelectorSettingItem<T> extends StatelessWidget {
  final String title;
  final T selectedValue;
  final String Function(T)? valueMap;
  final List<T> possibleValues;
  final void Function(T)? onPossibleValueSelect;
  final SubtitlePosition selectedValuePosition;
  final ConvertouchUITheme theme;

  const SelectorSettingItem({
    required this.title,
    required this.selectedValue,
    this.valueMap,
    required this.possibleValues,
    this.onPossibleValueSelect,
    this.selectedValuePosition = SubtitlePosition.bottom,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return ConvertouchSettingItem(
      title: title,
      subtitle: valueMap?.call(selectedValue) ?? selectedValue.toString(),
      subtitlePosition: selectedValuePosition,
      theme: theme,
      onTap: () {
        _showRadioDialog(context, colors: colors);
      },
    );
  }

  void _showRadioDialog(
    BuildContext context, {
    required SettingsColorScheme colors,
  }) {
    T currentValue = selectedValue;

    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return ConvertouchRadioDialog<T>(
              title: title,
              selectedValue: currentValue,
              valueMap: valueMap,
              possibleValues: possibleValues,
              colors: colors,
              onChanged: (newValue) {
                if (newValue != null) {
                  onPossibleValueSelect?.call(newValue);
                  setStateDialog(() {
                    currentValue = newValue;
                  });
                  Navigator.of(context).pop();
                }
              },
            );
          },
        );
      },
    ).then((returnedValue) {});
  }
}

class AboutSettingItem extends StatelessWidget {
  final String title;
  final String value;
  final SubtitlePosition selectedValuePosition;
  final ConvertouchUITheme theme;

  const AboutSettingItem({
    required this.title,
    required this.value,
    this.selectedValuePosition = SubtitlePosition.bottom,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return ConvertouchSettingItem(
      title: title,
      subtitle: value,
      subtitlePosition: selectedValuePosition,
      theme: theme,
      onTap: () {
        _showAboutDialog(
          context,
          colors: colors,
          applicationName: appName,
          applicationVersion: value,
          applicationLegalese: appLegalese,
        );
      },
    );
  }

  void _showAboutDialog(
    BuildContext context, {
    required SettingsColorScheme colors,
    required String applicationName,
    required String applicationVersion,
    required String applicationLegalese,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              backgroundColor: colors.settingItem.background.regular,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 2,
                    ),
                    child: IconUtils.getImage(
                      "app-logo.png",
                      size: 35,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicationName,
                        style: TextStyle(
                          fontSize: 21,
                          color: colors.settingItem.foreground.regular,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        applicationVersion,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.settingItem.foreground.regular,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          applicationLegalese,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.settingItem.foreground.regular,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(
                top: 10,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              actionsPadding: const EdgeInsets.only(
                right: 10,
                bottom: 5,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'View Licenses',
                    style: TextStyle(
                      color: colors.selectedValue.regular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    showLicensePage(
                      context: context,
                      applicationName: applicationName,
                      applicationVersion: applicationVersion,
                      applicationLegalese: applicationLegalese,
                    );
                  },
                ),
                TextButton(
                  child: Text(
                    'Close',
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

class RadioSettingItem<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? selectedValue;
  final bool disabled;
  final void Function(T) onSelect;
  final ConvertouchUITheme theme;

  const RadioSettingItem({
    required this.title,
    required this.value,
    this.selectedValue,
    this.disabled = false,
    required this.onSelect,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return ConvertouchSettingItem(
      title: title,
      leading: _radio(colors: colors),
      height: 52,
      padding: const EdgeInsets.only(
        left: 2,
        right: 10,
        top: 4,
        bottom: 4,
      ),
      theme: theme,
      onTap: () {
        if (!disabled) {
          onSelect.call(value);
        }
      },
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
