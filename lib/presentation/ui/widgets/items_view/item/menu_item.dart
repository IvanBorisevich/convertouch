import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/item_mode_icon.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem<T extends IdNameItemModel> extends StatelessWidget {
  static const double gridItemWidth = 80;
  static const double gridItemHeight = 80;
  static const double listItemHeight = 50;
  static const double defaultLogoIconSize = 29;

  final T item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onTapForRemoval;
  final double? width;
  final double? height;
  final double? logoIconSize;
  final bool marked;
  final bool selected;
  final bool disabled;
  final bool editIconVisible;
  final bool removalMode;
  final bool markedForRemoval;
  final ConvertouchUITheme theme;
  final ListItemColorScheme? customColors;

  const ConvertouchMenuItem(
    this.item, {
    required this.itemsViewMode,
    this.onTap,
    this.onLongPress,
    this.onTapForRemoval,
    this.marked = false,
    this.selected = false,
    this.disabled = false,
    this.editIconVisible = false,
    this.removalMode = false,
    this.markedForRemoval = false,
    this.width,
    this.height,
    this.logoIconSize,
    required this.theme,
    this.customColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ListItemColorScheme colorScheme;

    if (customColors != null) {
      colorScheme = customColors!;
    } else if (item.runtimeType == UnitGroupModel) {
      colorScheme = unitGroupItemColors[theme]!;
    } else {
      colorScheme = unitItemColors[theme]!;
    }

    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;
    Color dividerColor;

    if (selected) {
      backgroundColor = colorScheme.background.selected;
      foregroundColor = colorScheme.foreground.selected;
      borderColor = colorScheme.border.selected;
      dividerColor = colorScheme.divider.selected;
    } else if (marked) {
      backgroundColor = colorScheme.background.marked;
      foregroundColor = colorScheme.foreground.marked;
      borderColor = colorScheme.border.marked;
      dividerColor = colorScheme.divider.marked;
    } else if (disabled) {
      backgroundColor = colorScheme.background.disabled;
      foregroundColor = colorScheme.foreground.disabled;
      borderColor = colorScheme.border.disabled;
      dividerColor = colorScheme.divider.disabled;
    } else {
      backgroundColor = colorScheme.background.regular;
      foregroundColor = colorScheme.foreground.regular;
      borderColor = colorScheme.border.regular;
      dividerColor = colorScheme.divider.regular;
    }

    Widget itemLogo;
    String itemName;

    switch (item.runtimeType) {
      case UnitGroupModel:
        UnitGroupModel unitGroup = item as UnitGroupModel;
        itemLogo = IconUtils.getUnitGroupIcon(
          iconName: unitGroup.iconName,
          color: foregroundColor,
          size: logoIconSize ?? defaultLogoIconSize,
        );
        itemName = unitGroup.name;
        break;
      case UnitModel:
        UnitModel unit = item as UnitModel;
        itemLogo = Text(
          unit.code,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
        itemName =
            unit.symbol != null ? "${unit.name} (${unit.symbol})" : unit.name;
        break;
      default:
        itemLogo = empty();
        itemName = item.name;
        break;
    }

    return GestureDetector(
      onTap: () {
        if (removalMode) {
          if (!item.oob) {
            onTapForRemoval?.call();
          }
        } else {
          if (!selected && !disabled) {
            FocusScope.of(context).unfocus();
            onTap?.call();
          }
        }
      },
      onLongPress: onLongPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          switch (itemsViewMode) {
            case ItemsViewMode.grid:
              return ConvertouchMenuGridItem(
                item,
                itemName: itemName,
                removalMode: removalMode,
                editIconVisible: editIconVisible,
                markedForRemoval: markedForRemoval,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                dividerColor: dividerColor,
                removalIconColors: colorScheme.removalIcon,
                modeIconColors: colorScheme.modeIcon,
                width: width ?? gridItemWidth,
                height: height ?? gridItemHeight,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                item,
                itemName: itemName,
                height: height ?? listItemHeight,
                removalMode: removalMode,
                editIconVisible: editIconVisible,
                markedForRemoval: markedForRemoval,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                dividerColor: dividerColor,
                removalIconColors: colorScheme.removalIcon,
                modeIconColors: colorScheme.modeIcon,
              );
          }
        },
      ),
    );
  }
}

class ConvertouchMenuListItem extends StatelessWidget {
  final IdNameItemModel item;
  final String itemName;
  final bool removalMode;
  final bool editIconVisible;
  final Widget logo;
  final double height;
  final bool markedForRemoval;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color dividerColor;
  final ConvertouchColorScheme removalIconColors;
  final ConvertouchColorScheme modeIconColors;

  const ConvertouchMenuListItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.editIconVisible,
    required this.logo,
    this.height = 50,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.dividerColor,
    required this.removalIconColors,
    required this.modeIconColors,
    this.markedForRemoval = false,
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
                borderRadius: BorderRadius.circular(8),
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
                      if (item.oob) {
                        return empty();
                      }

                      if (removalMode) {
                        return ConvertouchItemModeIcon.checkbox(
                          active: markedForRemoval,
                          colors: removalIconColors,
                          padding: const EdgeInsets.only(right: 10),
                        );
                      }

                      if (editIconVisible) {
                        return ConvertouchItemModeIcon.edit(
                          colors: modeIconColors,
                          padding: const EdgeInsets.only(right: 10),
                        );
                      }

                      return empty();
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
