import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/common_utils.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/dialog/about_dialog.dart';
import 'package:convertouch/presentation/ui/widgets/dialog/radio_dialog.dart';
import 'package:flutter/material.dart';

enum SubtitlePosition {
  bottom,
  right,
}

const double _defaultItemHeight = 60;
const double _radioItemHeight = 52;
const double _bottomSubtitleHeight = 23;
const double _bottomSubtitleFontSize = 14;
const double _rightSubtitleFontSize = 14;

const EdgeInsets _defaultItemPadding = EdgeInsets.only(
  top: 7,
  bottom: 7,
  left: 15,
  right: 10,
);

class _ConvertouchSettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? leadingIconName;
  final IconData? leadingIconData;
  final Widget? leading;
  final Widget? trailing;
  final double? titleLineHeight;
  final SubtitlePosition? subtitlePosition;
  final double height;
  final EdgeInsets padding;
  final void Function()? onTap;
  final SettingItemColorScheme colors;

  const _ConvertouchSettingItem({
    required this.title,
    this.subtitle,
    this.leadingIconName,
    this.leadingIconData,
    this.leading,
    this.trailing,
    this.titleLineHeight,
    this.subtitlePosition,
    this.height = _defaultItemHeight,
    this.padding = _defaultItemPadding,
    this.onTap,
    required this.colors,
  }) : assert(
          leading == null || leadingIconName == null || leadingIconData == null,
          "Either 'leading', 'leadingIconName' or 'leadingIconData' can be provided",
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: colors.background.regular,
        ),
        child: Row(
          children: [
            leading ??
                _leadingIconByName(leadingIconName) ??
                _leadingIconByData(leadingIconData) ??
                const SizedBox.shrink(),
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

  Widget? _leadingIconByName(String? iconName) {
    if (iconName == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconUtils.getSvgIcon(
        iconName,
        color: colors.foreground.regular,
      ),
    );
  }

  Widget? _leadingIconByData(IconData? icon) {
    if (icon == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(
        icon,
        color: colors.foreground.regular,
      ),
    );
  }

  Widget _title(SettingItemColorScheme colors) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: colors.foreground.regular,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            height: titleLineHeight,
          ),
        ),
      ),
    );
  }

  Widget? _subtitle(SettingItemColorScheme colors) {
    if (subtitle == null) {
      return null;
    }

    double fontSize = subtitlePosition == SubtitlePosition.bottom
        ? _bottomSubtitleFontSize
        : _rightSubtitleFontSize;

    return Container(
      height: subtitlePosition == SubtitlePosition.bottom
          ? _bottomSubtitleHeight
          : null,
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
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class SwitcherSettingItem extends StatelessWidget {
  final String title;
  final bool value;
  final IconData? leadingIconData;
  final String? leadingIconName;
  final void Function(bool)? onSwitch;
  final ConvertouchUITheme theme;

  const SwitcherSettingItem({
    required this.title,
    required this.value,
    this.leadingIconData,
    this.leadingIconName,
    this.onSwitch,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingItemColorScheme colors = appColors[theme].settingGroup.settingItem;

    return _ConvertouchSettingItem(
      title: title,
      leadingIconData: leadingIconData,
      leadingIconName: leadingIconName,
      titleLineHeight: 1.1,
      trailing: _switch(
        colors: colors,
        active: value,
      ),
      onTap: () {
        onSwitch?.call(!value);
      },
      colors: colors,
    );
  }

  Widget _switch({
    required SettingItemColorScheme colors,
    bool active = false,
  }) {
    return Switch.adaptive(
      value: active,
      activeColor: colors.foreground.selected,
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          return colors.foreground.regular;
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
  final IconData? leadingIconData;
  final String? leadingIconName;
  final String Function(T)? valueMap;
  final List<T> possibleValues;
  final void Function(T)? onPossibleValueSelect;
  final SubtitlePosition selectedValuePosition;
  final ConvertouchUITheme theme;

  const SelectorSettingItem({
    required this.title,
    required this.selectedValue,
    this.leadingIconData,
    this.leadingIconName,
    this.valueMap,
    required this.possibleValues,
    this.onPossibleValueSelect,
    this.selectedValuePosition = SubtitlePosition.bottom,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingItemColorScheme colors = appColors[theme].settingGroup.settingItem;

    return _ConvertouchSettingItem(
      title: title,
      leadingIconData: leadingIconData,
      leadingIconName: leadingIconName,
      subtitle: valueMap?.call(selectedValue) ?? selectedValue.toString(),
      subtitlePosition: selectedValuePosition,
      colors: colors,
      onTap: () {
        _showRadioDialog(context, colors: colors);
      },
    );
  }

  void _showRadioDialog(
    BuildContext context, {
    required SettingItemColorScheme colors,
  }) {
    T currentValue = selectedValue;

    showConvertouchDialog<T>(
      context: context,
      currentTheme: theme,
      builder: (context, setStateDialog) {
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
    ).then((returnedValue) {});
  }
}

class AboutSettingItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData? leadingIconData;
  final String? leadingIconName;
  final SubtitlePosition selectedValuePosition;
  final ConvertouchUITheme theme;

  const AboutSettingItem({
    required this.title,
    required this.value,
    this.leadingIconData,
    this.leadingIconName,
    this.selectedValuePosition = SubtitlePosition.bottom,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingItemColorScheme colors = appColors[theme].settingGroup.settingItem;

    return _ConvertouchSettingItem(
      title: title,
      subtitle: value,
      subtitlePosition: selectedValuePosition,
      leadingIconData: leadingIconData,
      leadingIconName: leadingIconName,
      colors: colors,
      onTap: () {
        _showAboutDialog(
          context,
          colors: colors,
          theme: theme,
          applicationVersion: value,
        );
      },
    );
  }

  void _showAboutDialog(
    BuildContext context, {
    required SettingItemColorScheme colors,
    required ConvertouchUITheme theme,
    required String applicationVersion,
  }) {
    showConvertouchDialog(
      currentTheme: theme,
      context: context,
      builder: (context, setStateDialog) {
        return ConvertouchAboutDialog(
          applicationVersion: applicationVersion,
          colors: colors,
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
    SettingItemColorScheme colors = appColors[theme].settingGroup.settingItem;

    return _ConvertouchSettingItem(
      title: title,
      leading: _radio(colors: colors),
      height: _radioItemHeight,
      padding: const EdgeInsets.only(
        left: 2,
        right: 10,
        top: 4,
        bottom: 4,
      ),
      colors: colors,
      onTap: () {
        if (!disabled) {
          onSelect.call(value);
        }
      },
    );
  }

  Widget _radio({
    required SettingItemColorScheme colors,
  }) {
    return Radio<T>.adaptive(
      groupValue: selectedValue,
      value: value,
      onChanged: null,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.foreground.selected;
        }
        if (states.contains(WidgetState.disabled)) {
          return colors.foreground.disabled;
        }
        return colors.foreground.regular;
      }),
    );
  }
}
