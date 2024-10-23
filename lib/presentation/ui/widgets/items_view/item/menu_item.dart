import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
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
