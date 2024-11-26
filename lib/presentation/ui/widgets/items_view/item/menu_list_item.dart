import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem<T extends IdNameItemModel>
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
  final Widget Function(T, Color) logoFunc;
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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: defaultHeight * 1.5,
            height: defaultHeight,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 7,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: disabled
                  ? colors.background.disabled
                  : colors.background.regular,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                bottomLeft: Radius.circular(_borderRadius),
              ),
            ),
            child: logoFunc.call(
              item,
              disabled ? colors.foreground.disabled : colors.foreground.regular,
            ),
          ),
          Expanded(
            child: Container(
              height: defaultHeight,
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: disabled
                    ? colors.background.disabled
                    : colors.background.regular,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Text(
                itemName,
                style: TextStyle(
                  fontFamily: quicksandFontFamily,
                  fontWeight: FontWeight.w600,
                  color: disabled
                      ? colors.foreground.disabled
                      : colors.foreground.regular,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          checkIconVisible && (checkIconVisibleIfUnchecked || checked)
              ? ConvertouchItemModeIcon.checkbox(
                  active: checked,
                  colors: colors.checkBox,
                  padding: const EdgeInsets.only(right: 10),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          editIconVisible
              ? ConvertouchItemModeIcon.edit(
                  colors: colors.modeIcon,
                  padding: const EdgeInsets.only(right: 10),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }
}
