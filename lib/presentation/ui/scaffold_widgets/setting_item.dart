import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

enum PointerSide {
  none,
  left,
  right,
}

class SettingItem<T> extends StatelessWidget {
  final String title;
  final bool selected;
  final Widget child;
  final void Function()? onTap;
  final PointerSide pointerSide;
  final bool showDivider;
  final bool disabled;
  final ConvertouchUITheme theme;

  SettingItem.regular({
    required this.title,
    this.onTap,
    this.showDivider = true,
    this.disabled = false,
    required this.theme,
    super.key,
  })  : pointerSide = PointerSide.none,
        selected = false,
        child = empty();

  SettingItem.radio({
    required T value,
    T? selectedValue,
    required String Function(T) titleMapper,
    void Function(T)? onChanged,
    this.pointerSide = PointerSide.left,
    this.showDivider = true,
    this.disabled = false,
    required this.theme,
    super.key,
  })  : selected = selectedValue == value,
        child = _buildRadio(
          value: value,
          selectedValue: selectedValue,
          onChanged: onChanged,
          disabled: disabled,
          theme: theme,
        ),
        title = titleMapper.call(value),
        onTap = _buildFunc(
          inputValue: value,
          func: onChanged,
        );

  SettingItem.switcher({
    required this.selected,
    required this.title,
    void Function(bool)? onChanged,
    this.pointerSide = PointerSide.right,
    this.showDivider = true,
    this.disabled = false,
    required this.theme,
    super.key,
  })  : child = _buildSwitcher(
          value: selected,
          onTap: onChanged,
          disabled: disabled,
          theme: theme,
        ),
        onTap = _buildFunc<bool>(
          inputValue: selected,
          func: onChanged,
        );

  static Widget _buildRadio<T>({
    required T value,
    T? selectedValue,
    void Function(T)? onChanged,
    required bool disabled,
    required ConvertouchUITheme theme,
  }) {
    ColorStateVariation<SettingItemColorSet> itemColor =
        settingItemColors[theme]!;

    return Radio<T>.adaptive(
      groupValue: selectedValue,
      value: value,
      onChanged: (T? newValue) {
        if (!disabled && newValue != null) {
          onChanged?.call(newValue);
        }
      },
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return itemColor.selected!.foreground;
        }
        if (states.contains(MaterialState.disabled)) {
          return itemColor.disabled!.foreground;
        }
        return itemColor.regular.foreground;
      }),
    );
  }

  static Widget _buildSwitcher({
    required bool value,
    void Function(bool)? onTap,
    required bool disabled,
    required ConvertouchUITheme theme,
  }) {
    ColorStateVariation<SettingItemColorSet> itemColor =
        settingItemColors[theme]!;

    return Switch(
      value: value,
      activeColor: itemColor.selected!.foreground,
      thumbColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return itemColor.disabled!.foreground;
          }
          return itemColor.regular.foreground;
        },
      ),
      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return itemColor.selected!.switcher.track.border;
        }
        if (states.contains(MaterialState.disabled)) {
          return itemColor.disabled!.switcher.track.border;
        }
        return itemColor.regular.switcher.track.border;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return itemColor.selected!.switcher.track.background;
        }
        if (states.contains(MaterialState.disabled)) {
          return itemColor.disabled!.switcher.track.background;
        }
        return itemColor.regular.switcher.track.background;
      }),
      onChanged: (bool newValue) {
        onTap?.call(newValue);
      },
    );
  }

  static void Function() _buildFunc<T>({
    required T inputValue,
    void Function(T)? func,
  }) {
    return () {
      func?.call(inputValue);
    };
  }

  @override
  Widget build(BuildContext context) {
    SettingItemColorSet itemColor = disabled
        ? settingItemColors[theme]!.disabled!
        : settingItemColors[theme]!.regular;

    return InkWell(
      onTap: () {
        if (!disabled && !selected) {
          onTap?.call();
        }
      },
      child: Column(
        children: [
          showDivider
              ? Divider(
                  height: 1,
                  indent: pointerSide != PointerSide.left ? 15 : 40,
                  color: itemColor.divider,
                )
              : empty(),
          pointerSide != PointerSide.left
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      child: Text(title),
                    ),
                    Expanded(
                      child: Align(
                        alignment: pointerSide == PointerSide.right
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    child,
                    Text(title),
                  ],
                ),
        ],
      ),
    );
  }
}
