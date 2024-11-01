import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatelessWidget {
  final IdNameItemModel item;
  final String itemName;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool editIconVisible;
  final Widget logo;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color titleBackgroundColor;
  final Color foregroundColor;
  final Color borderColor;
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
    required this.borderColor,
    required this.dividerColor,
    required this.checkBoxIconColors,
    required this.modeIconColors,
    required this.width,
    required this.height,
    this.borderRadius = 7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: 0,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: height * 0.6,
            child: Stack(
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: quicksandFontFamily,
                    fontSize: 16,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    child: logo,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (checkIconVisible &&
                        (checkIconVisibleIfUnchecked || checked)) {
                      return ConvertouchItemModeIcon.checkbox(
                        active: checked,
                        colors: checkBoxIconColors,
                        padding: const EdgeInsets.only(left: 1, top: 1),
                      );
                    }

                    if (editIconVisible) {
                      return ConvertouchItemModeIcon.edit(
                        colors: modeIconColors,
                        padding: const EdgeInsets.only(left: 2, top: 2),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: titleBackgroundColor,
              border: Border.all(
                width: 0,
                color: borderColor,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
            ),
            width: width,
            height: height * (1 - 0.6),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5, right: 5),
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
          ),
        ],
      ),
    );
  }
}

// final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
// const int _minGridItemWordSizeToWrap = 10;
//
// int _getGridItemNameLinesNumToWrap(String gridItemName) {
//   return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
//       ? 1
//       : 2;
// }
