import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatelessWidget {
  static const double defaultWidth = 80;
  static const double defaultHeight = 80;
  static const double defaultBorderRadius = 7;

  final IdNameItemModel item;
  final String itemName;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool editIconVisible;
  final Widget logo;
  final Color backgroundColor;
  final Color titleBackgroundColor;
  final Color foregroundColor;
  final Color dividerColor;
  final ConvertouchColorScheme checkBoxIconColors;
  final ConvertouchColorScheme modeIconColors;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.itemName,
    required this.checkIconVisible,
    required this.checkIconVisibleIfUnchecked,
    required this.checked,
    required this.editIconVisible,
    required this.logo,
    required this.backgroundColor,
    required this.titleBackgroundColor,
    required this.foregroundColor,
    required this.dividerColor,
    required this.checkBoxIconColors,
    required this.modeIconColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: defaultWidth,
      height: defaultHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Stack(
        children: [
          checkIconVisible && (checkIconVisibleIfUnchecked || checked)
              ? ConvertouchItemModeIcon.checkbox(
                  active: checked,
                  colors: checkBoxIconColors,
                  padding: const EdgeInsets.only(left: 1, top: 1),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          editIconVisible
              ? ConvertouchItemModeIcon.edit(
                  colors: modeIconColors,
                  padding: const EdgeInsets.only(left: 2, top: 2),
                )
              : const SizedBox(width: 0, height: 0),
          Column(
            children: [
              SizedBox(
                width: defaultWidth,
                height: defaultHeight * 0.6,
                child: Center(child: logo),
              ),
              Container(
                width: defaultWidth,
                height: defaultHeight * (1 - 0.6),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: titleBackgroundColor,
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
                    color: foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
