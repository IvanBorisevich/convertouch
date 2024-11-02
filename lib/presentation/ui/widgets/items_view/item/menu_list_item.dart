import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem extends StatelessWidget {
  final IdNameItemModel item;
  final String itemName;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool checked;
  final bool editIconVisible;
  final Widget logo;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
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
    required this.height,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.dividerColor,
    required this.checkBoxIconColors,
    required this.modeIconColors,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: quicksandFontFamily,
                      fontSize: 16,
                    ),
                    child: Container(
                      width: height * 1.4,
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
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
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (checkIconVisible &&
                          (checkIconVisibleIfUnchecked || checked)) {
                        return ConvertouchItemModeIcon.checkbox(
                          active: checked,
                          colors: checkBoxIconColors,
                          padding: const EdgeInsets.only(right: 10),
                        );
                      }

                      if (editIconVisible) {
                        return ConvertouchItemModeIcon.edit(
                          colors: modeIconColors,
                          padding: const EdgeInsets.only(right: 10),
                        );
                      }

                      return const SizedBox(
    height: 0,
    width: 0,
  );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
