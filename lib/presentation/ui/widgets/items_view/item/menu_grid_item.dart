import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem<T extends IdNameItemModel>
    extends StatelessWidget {
  static const double defaultWidth = 80;
  static const double defaultHeight = 80;
  static const double defaultBorderRadius = 7;

  final T item;
  final String itemName;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool disabled;
  final bool editIconVisible;
  final Widget Function(T, Color) logoFunc;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final ListItemColorScheme colors;

  const ConvertouchMenuGridItem(
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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          checkIconVisible && (checkIconVisibleIfUnchecked || checked)
              ? ConvertouchItemModeIcon.checkbox(
                  active: checked,
                  colors: colors.checkBox,
                  padding: const EdgeInsets.only(left: 1, top: 1),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          editIconVisible
              ? ConvertouchItemModeIcon.edit(
                  colors: colors.modeIcon,
                  padding: const EdgeInsets.only(left: 2, top: 2),
                )
              : const SizedBox(width: 0, height: 0),
          Column(
            children: [
              Container(
                width: defaultWidth,
                height: defaultHeight * 0.6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.background.disabled
                      : colors.background.regular,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(defaultBorderRadius),
                    topRight: Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: logoFunc.call(
                  item,
                  disabled
                      ? colors.foreground.disabled
                      : colors.foreground.regular,
                ),
              ),
              Container(
                width: defaultWidth,
                height: defaultHeight * (1 - 0.6),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.titleBackground.disabled
                      : colors.titleBackground.regular,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(defaultBorderRadius),
                    bottomRight: Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: Text(
                  itemName,
                  style: TextStyle(
                    fontFamily: quicksandFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: disabled
                        ? colors.foreground.disabled
                        : colors.foreground.regular,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
