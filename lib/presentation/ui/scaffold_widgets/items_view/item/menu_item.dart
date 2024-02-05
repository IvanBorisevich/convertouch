import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/checkbox.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem extends StatelessWidget {
  static const double gridItemWidth = 80;
  static const double gridItemHeight = 80;
  static const double listItemHeight = 50;

  final IdNameItemModel item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onTapForRemoval;
  final double? width;
  final double? height;
  final bool marked;
  final bool selected;
  final bool removalMode;
  final bool markedForRemoval;
  final ConvertouchUITheme theme;
  final ColorStateVariation<BaseColorSet>? customColors;

  const ConvertouchMenuItem(
    this.item, {
    required this.itemsViewMode,
    this.onTap,
    this.onLongPress,
    this.onTapForRemoval,
    this.marked = false,
    this.selected = false,
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
    ColorStateVariation<BaseColorSet> itemColor;
    BaseColorSet itemColorSet;

    if (customColors != null) {
      itemColor = customColors!;
    } else if (item.runtimeType == UnitGroupModel) {
      itemColor = unitGroupItemColors[theme]!;
    } else {
      itemColor = unitItemColors[theme]!;
    }

    if (selected) {
      itemColorSet = itemColor.selected!;
    } else if (marked) {
      itemColorSet = itemColor.marked!;
    } else {
      itemColorSet = itemColor.regular;
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
            color: itemColorSet.foreground,
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
        itemLogo = IconButton(
          onPressed: null,
          icon: ImageIcon(
            const AssetImage(
              "$iconAssetsPathPrefix/$unitGroupDefaultIconName",
            ),
            color: itemColorSet.foreground,
            size: 25,
          ),
        );
        itemName = item.name;
        break;
    }

    return GestureDetector(
      onTap: () {
        if (removalMode) {
          onTapForRemoval?.call();
        } else {
          if (!selected) {
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
                markedForConversion: selected,
                logo: itemLogo,
                color: itemColorSet,
                width: width ?? gridItemWidth,
                height: height ?? gridItemHeight,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                item,
                itemName: itemName,
                height: height ?? listItemHeight,
                removalMode: removalMode,
                selectedForRemoval: markedForRemoval,
                selectedForConversion: selected,
                logo: itemLogo,
                color: itemColorSet,
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
  final bool selectedForRemoval;
  final bool selectedForConversion;
  final BaseColorSet color;

  const ConvertouchMenuListItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.logo,
    this.height = 50,
    required this.color,
    this.selectedForRemoval = false,
    this.selectedForConversion = false,
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
                color: color.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  strokeAlign: selectedForConversion
                      ? BorderSide.strokeAlignOutside
                      : BorderSide.strokeAlignInside,
                  color: color.border,
                  width: selectedForConversion ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  removalMode
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ConvertouchCheckbox(
                            selectedForRemoval,
                            color: color.border,
                            colorChecked: color.foreground,
                          ),
                        )
                      : empty(),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: color.foreground,
                      fontWeight: FontWeight.w700,
                      fontFamily: quicksandFontFamily,
                      fontSize: 16,
                    ),
                    child: logo,
                  ),
                  VerticalDivider(
                    width: selectedForConversion ? 3 : 1,
                    thickness: selectedForConversion ? 2 : 1,
                    indent: 5,
                    endIndent: 5,
                    color: color.border,
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
                            color: color.foreground,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
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
  final Widget logo;
  final bool markedForRemoval;
  final bool markedForConversion;
  final double width;
  final double height;
  final BaseColorSet color;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.itemName,
    required this.removalMode,
    required this.logo,
    required this.color,
    this.markedForRemoval = false,
    this.markedForConversion = false,
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
        color: color.background,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          strokeAlign: markedForConversion
              ? BorderSide.strokeAlignOutside
              : BorderSide.strokeAlignInside,
          color: color.border,
          width: markedForConversion ? 2 : 1,
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
                    color: color.foreground,
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
                          color: color.foreground,
                          colorChecked: color.foreground,
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
                  color: color.foreground,
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
