import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView<T extends IdNameItemModel>
    extends StatelessWidget {
  final List<T> items;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final int? selectedItemId;
  final bool editableItemsVisible;
  final bool checkableItemsVisible;
  final bool removalModeEnabled;
  final double itemsSpacing;
  final double itemsSpacingBottom;
  final ItemsViewMode itemsViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.selectedItemId,
    this.editableItemsVisible = false,
    this.checkableItemsVisible = false,
    this.removalModeEnabled = false,
    this.itemsSpacing = 8,
    this.itemsSpacingBottom = 85,
    required this.itemsViewMode,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (items.isNotEmpty) {
            Widget? itemBuilder(context, index) {
              T item = items[index];
              bool selected = item.id == selectedItemId;
              bool disabled = disabledItemIds.contains(item.id);
              bool checked = checkedItemIds.contains(item.id);

              return ConvertouchMenuItem(
                item,
                itemsViewMode: itemsViewMode,
                onTap: () {
                  if (removalModeEnabled) {
                    if (!item.oob) {
                      onItemTapForRemoval?.call(item);
                    }
                  } else {
                    if (!selected && !disabled) {
                      FocusScope.of(context).unfocus();
                      onItemTap?.call(item);
                    }
                  }
                },
                onLongPress: () {
                  onItemLongPress?.call(item);
                },
                checked: checked || selected,
                disabled: disabled,
                checkIconVisible: checkableItemsVisible || removalModeEnabled,
                checkIconVisibleIfUnchecked: !item.oob && removalModeEnabled,
                editIconVisible: !item.oob && editableItemsVisible,
                theme: theme,
              );
            }

            switch (itemsViewMode) {
              case ItemsViewMode.grid:
                return Padding(
                  padding: EdgeInsets.all(itemsSpacing),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: itemsSpacingBottom,
                        ),
                        sliver: SliverGrid.builder(
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: ConvertouchMenuItem.gridItemHeight,
                            maxCrossAxisExtent:
                                ConvertouchMenuItem.gridItemWidth,
                            mainAxisSpacing: itemsSpacing,
                            crossAxisSpacing: itemsSpacing,
                          ),
                          itemBuilder: itemBuilder,
                        ),
                      ),
                    ],
                  ),
                );
              case ItemsViewMode.list:
                return ListView.separated(
                  padding: EdgeInsets.only(
                    left: itemsSpacing,
                    top: itemsSpacing,
                    right: itemsSpacing,
                    bottom: itemsSpacingBottom,
                  ),
                  itemCount: items.length,
                  itemBuilder: itemBuilder,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: itemsSpacing,
                      top: itemsSpacing,
                      right: itemsSpacing,
                      bottom:
                          index == items.length - 1 ? itemsSpacingBottom : 0,
                    ),
                  ),
                );
            }
          }

          Color? foreground;
          if (T == UnitGroupModel) {
            foreground = unitGroupPageEmptyViewColor[theme]!.foreground.regular;
          } else if (T == UnitModel) {
            foreground = unitPageEmptyViewColor[theme]!.foreground.regular;
          }

          return SizedBox(
            child: Center(
              child: Text(
                T == UnitGroupModel ? "No Groups" : "No Units",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: foreground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
