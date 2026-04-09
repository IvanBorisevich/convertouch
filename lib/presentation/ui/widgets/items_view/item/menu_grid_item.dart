import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:convertouch/presentation/ui/widgets/text_search_match.dart';
import 'package:flutter/material.dart';

const int _titleMaxLines = 2;
const double _titleHeightFactor = 0.4;
const double _defaultBorderRadius = 17;
const double _logoFontSize = 20;

class ConvertouchMenuGridItem<T extends IdNameSearchableItemModel>
    extends StatelessWidget {
  final T item;
  final double width;
  final double height;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool disabled;
  final bool editIconVisible;
  final Widget Function(
    T, {
    required Color foreground,
    required Color matchForeground,
    required Color matchBackground,
    required double fontSize,
  }) logoFunc;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final MenuItemColorScheme colors;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.width,
    required this.height,
    required this.checkIconVisible,
    required this.checkIconVisibleIfUnchecked,
    required this.checked,
    required this.disabled,
    required this.editIconVisible,
    required this.logoFunc,
    this.onTap,
    this.onLongPress,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color background =
        disabled ? colors.background.disabled : colors.background.regular;
    Color foreground =
        disabled ? colors.foreground.disabled : colors.foreground.regular;
    Color titleBackground = disabled
        ? colors.titleBackground.disabled
        : colors.titleBackground.regular;
    Color matchBackground = colors.matchBackground.regular;
    Color matchForeground = colors.matchForeground.regular;

    double titleHeight = height * _titleHeightFactor;
    double titleFontSize = titleHeight / (_titleMaxLines + 1);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(
            Radius.circular(_defaultBorderRadius),
          ),
        ),
        child: Stack(
          children: [
            checkIconVisible && (checkIconVisibleIfUnchecked || checked)
                ? ConvertouchItemModeIcon.checkbox(
                    active: checked,
                    colors: colors.checkBox,
                  )
                : Column(
                    children: [
                      editIconVisible
                          ? ConvertouchItemModeIcon.edit(
                              colors: colors.modeIcon,
                              padding: const EdgeInsets.only(left: 3, top: 3),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
            Column(
              children: [
                Expanded(
                  child: logoFunc.call(
                    item,
                    foreground: foreground,
                    matchForeground: matchForeground,
                    matchBackground: matchBackground,
                    fontSize: _logoFontSize,
                  ),
                ),
                Container(
                  height: titleHeight,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: titleBackground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(_defaultBorderRadius),
                      bottomRight: Radius.circular(_defaultBorderRadius),
                    ),
                  ),
                  child: TextSearchMatch(
                    sourceString: item.itemName,
                    match: item.nameMatch,
                    foreground: foreground,
                    matchBackground: matchBackground,
                    matchForeground: matchForeground,
                    fontSize: titleFontSize,
                    maxLines: _titleMaxLines,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
