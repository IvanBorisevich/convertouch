import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem extends StatelessWidget {
  static const double defaultHeight = 50;
  static const double defaultBorderRadius = 7;

  final IdNameItemModel item;
  final String itemName;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool editIconVisible;
  final Widget logo;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color dividerColor;
  final ConvertouchColorScheme checkBoxIconColors;
  final ConvertouchColorScheme modeIconColors;

  const ConvertouchMenuListItem(
    this.item, {
    required this.itemName,
    required this.checkIconVisible,
    required this.checkIconVisibleIfUnchecked,
    required this.checked,
    required this.editIconVisible,
    required this.logo,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.dividerColor,
    required this.checkBoxIconColors,
    required this.modeIconColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: defaultHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Row(
        children: [
          SizedBox(
            width: defaultHeight * 1.4,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 7,
              ),
              child: Center(child: logo),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: dividerColor,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                itemName,
                style: TextStyle(
                  fontFamily: quicksandFontFamily,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          checkIconVisible && (checkIconVisibleIfUnchecked || checked)
              ? ConvertouchItemModeIcon.checkbox(
                  active: checked,
                  colors: checkBoxIconColors,
                  padding: const EdgeInsets.only(right: 10),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          editIconVisible
              ? ConvertouchItemModeIcon.edit(
                  colors: modeIconColors,
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
