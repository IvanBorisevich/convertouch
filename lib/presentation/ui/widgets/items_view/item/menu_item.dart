import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem<T extends IdNameItemModel> extends StatelessWidget {
  static const double defaultLogoIconSize = 29;
  static const double defaultBorderRadius = 7;

  final T item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool checked;
  final bool disabled;
  final bool editIconVisible;
  final bool checkIconVisible;
  final bool checkIconVisibleIfUnchecked;
  final ConvertouchUITheme theme;
  final ListItemColorScheme? customColors;

  const ConvertouchMenuItem(
    this.item, {
    required this.itemsViewMode,
    this.onTap,
    this.onLongPress,
    this.checked = false,
    this.disabled = false,
    this.editIconVisible = false,
    this.checkIconVisible = false,
    this.checkIconVisibleIfUnchecked = false,
    this.width,
    this.height,
    this.borderRadius = defaultBorderRadius,
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
    Color titleBackgroundColor;

    if (disabled) {
      backgroundColor = colorScheme.background.disabled;
      foregroundColor = colorScheme.foreground.disabled;
      borderColor = colorScheme.border.disabled;
      dividerColor = colorScheme.divider.disabled;
      titleBackgroundColor = colorScheme.titleBackground.disabled;
    } else {
      backgroundColor = colorScheme.background.regular;
      foregroundColor = colorScheme.foreground.regular;
      borderColor = colorScheme.border.regular;
      dividerColor = colorScheme.divider.regular;
      titleBackgroundColor = colorScheme.titleBackground.regular;
    }

    Widget itemLogo;
    String itemName;

    switch (item.runtimeType) {
      case UnitGroupModel:
        UnitGroupModel unitGroup = item as UnitGroupModel;
        itemLogo = IconUtils.getUnitGroupIcon(
          iconName: unitGroup.iconName,
          color: foregroundColor,
          size: defaultLogoIconSize,
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
        itemLogo = const SizedBox(
          height: 0,
          width: 0,
        );
        itemName = item.name;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          switch (itemsViewMode) {
            case ItemsViewMode.grid:
              return ConvertouchMenuGridItem(
                item,
                itemName: itemName,
                checkIconVisible: checkIconVisible,
                checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
                checked: checked,
                editIconVisible: editIconVisible,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                titleBackgroundColor: titleBackgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                dividerColor: dividerColor,
                checkBoxIconColors: colorScheme.checkBox,
                modeIconColors: colorScheme.modeIcon,
                borderRadius: borderRadius,
                width: width ?? ConvertouchMenuGridItem.defaultWidth,
                height: height ?? ConvertouchMenuGridItem.defaultHeight,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                item,
                itemName: itemName,
                checkIconVisible: checkIconVisible,
                checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
                checked: checked,
                editIconVisible: editIconVisible,
                logo: itemLogo,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                borderColor: borderColor,
                dividerColor: dividerColor,
                checkBoxIconColors: colorScheme.checkBox,
                modeIconColors: colorScheme.modeIcon,
                borderRadius: borderRadius,
                height: height ?? ConvertouchMenuListItem.defaultHeight,
              );
          }
        },
      ),
    );
  }
}
