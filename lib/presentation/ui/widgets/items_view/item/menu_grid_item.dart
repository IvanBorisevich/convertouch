import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatelessWidget {
  final IdNameItemModel item;
  final String itemName;
  final bool removalMode;
  final bool editIconVisible;
  final Widget logo;
  final bool markedForRemoval;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color dividerColor;
  final ConvertouchColorScheme removalIconColors;
  final ConvertouchColorScheme modeIconColors;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.editIconVisible,
    required this.logo,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.dividerColor,
    required this.removalIconColors,
    required this.modeIconColors,
    this.markedForRemoval = false,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: borderColor,
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
                    if (item.oob) {
                      return empty();
                    }

                    if (removalMode) {
                      return ConvertouchItemModeIcon.checkbox(
                        active: markedForRemoval,
                        colors: removalIconColors,
                        padding: const EdgeInsets.only(left: 3, top: 3),
                      );
                    }

                    if (editIconVisible) {
                      return ConvertouchItemModeIcon.edit(
                        colors: modeIconColors,
                        padding: const EdgeInsets.only(left: 2, top: 2),
                      );
                    }

                    return empty();
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: foregroundColor,
            indent: 7,
            endIndent: 7,
          ),
          Container(
            width: width,
            height: height * 0.3,
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
