import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/checkbox.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem<T extends IdNameItemModel> extends StatelessWidget {
  static const double gridItemWidth = 80;
  static const double gridItemHeight = 80;
  static const double listItemHeight = 50;

  final T item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onTapForRemoval;
  final double? width;
  final double? height;
  final bool marked;
  final bool selected;
  final bool disabled;
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
    this.removalMode = false,
    this.markedForRemoval = false,
    this.width,
    this.height,
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
        itemLogo = IconButton(
          onPressed: null,
          icon: ImageIcon(
            AssetImage(
              "$iconAssetsPathPrefix/${unitGroup.iconName}",
            ),
            color: foregroundColor,
            size: 25,
          ),
        );
        itemName = unitGroup.name;
        break;
      case UnitModel:
        UnitModel unit = item as UnitModel;
        itemLogo = SizedBox(
          width: 65,
          child: Center(
            child: Text(unit.code),
          ),
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
                markedForRemoval: markedForRemoval,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                width: width ?? gridItemWidth,
                height: height ?? gridItemHeight,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                item,
                itemName: itemName,
                height: height ?? listItemHeight,
                removalMode: removalMode,
                markedForRemoval: markedForRemoval,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                dividerColor: dividerColor,
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
  final Widget logo;
  final double height;
  final bool markedForRemoval;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color dividerColor;

  const ConvertouchMenuListItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.logo,
    this.height = 50,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.dividerColor,
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
                    child: logo,
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
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
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
                  removalMode && !item.oob
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ConvertouchCheckbox(
                            markedForRemoval,
                            color: foregroundColor,
                            colorChecked: foregroundColor,
                          ),
                        )
                      : empty(),
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
  final Widget logo;
  final bool markedForRemoval;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.logo,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
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
          Flexible(
            flex: 5,
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
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: logo,
                  ),
                ),
                removalMode && !item.oob
                    ? Padding(
                        padding: const EdgeInsets.only(left: 3, top: 3),
                        child: ConvertouchCheckbox(
                          markedForRemoval,
                          size: 12,
                          color: foregroundColor,
                          colorChecked: foregroundColor,
                        ),
                      )
                    : empty(),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
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
                maxLines: _getGridItemNameLinesNumToWrap(itemName),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;

int _getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}
