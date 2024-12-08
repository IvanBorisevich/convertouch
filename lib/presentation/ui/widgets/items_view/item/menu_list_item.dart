import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:convertouch/presentation/ui/widgets/text_search_match.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem<T extends IdNameSearchableItemModel>
    extends StatelessWidget {
  static const double defaultHeight = 50;
  static const double _borderRadius = 15;

  final T item;
  final String itemName;
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
  }) logoFunc;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final ListItemColorScheme colors;

  const ConvertouchMenuListItem(
    this.item, {
    required this.itemName,
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
    Color divider = disabled ? colors.divider.disabled : colors.divider.regular;

    Color matchBackground = colors.matchBackground.regular;
    Color matchForeground = colors.matchForeground.regular;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: defaultHeight,
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
        ),
        child: Row(
          children: [
            Container(
              width: defaultHeight * 1.7,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: logoFunc.call(
                item,
                foreground: foreground,
                matchForeground: matchForeground,
                matchBackground: matchBackground,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: divider,
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: TextSearchMatch(
                sourceString: itemName,
                match: item.nameMatch,
                foreground: foreground,
                matchBackground: matchBackground,
                matchForeground: matchForeground,
              ),
            ),
            checkIconVisible && (checkIconVisibleIfUnchecked || checked)
                ? ConvertouchItemModeIcon.checkbox(
                    active: checked,
                    colors: colors.checkBox,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        editIconVisible
                            ? ConvertouchItemModeIcon.edit(
                                colors: colors.modeIcon,
                                size: 11,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
