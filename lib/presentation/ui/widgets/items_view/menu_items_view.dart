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
  final List<int>? itemIdsMarkedForConversion;
  final List<int> itemIdsMarkedForRemoval;
  final bool showMarkedItems;
  final int? selectedItemId;
  final int? disabledItemId;
  final bool showSelectedItem;
  final bool removalModeAllowed;
  final bool removalModeEnabled;
  final double itemsSpacing;
  final ItemsViewMode itemsViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.itemIdsMarkedForConversion,
    this.itemIdsMarkedForRemoval = const [],
    this.showMarkedItems = false,
    this.selectedItemId,
    this.disabledItemId,
    this.showSelectedItem = false,
    this.removalModeAllowed = false,
    this.removalModeEnabled = false,
    this.itemsSpacing = 8,
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
              bool selected = showSelectedItem && item.id == selectedItemId;
              bool disabled = item.id == disabledItemId;
              bool marked = showMarkedItems &&
                  itemIdsMarkedForConversion != null &&
                  itemIdsMarkedForConversion!.contains(item.id);

              return ConvertouchMenuItem(
                item,
                itemsViewMode: itemsViewMode,
                onTap: () {
                  onItemTap?.call(item);
                },
                onLongPress: () {
                  onItemLongPress?.call(item);
                },
                onTapForRemoval: () {
                  onItemTapForRemoval?.call(item);
                },
                marked: marked,
                selected: selected,
                disabled: disabled,
                removalMode: removalModeAllowed && removalModeEnabled,
                markedForRemoval: itemIdsMarkedForRemoval.contains(item.id!),
                theme: theme,
              );
            }

            switch (itemsViewMode) {
              case ItemsViewMode.grid:
                return Padding(
                  padding: EdgeInsets.all(itemsSpacing),
                  child: CustomScrollView(
                    slivers: [
                      SliverGrid.builder(
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: ConvertouchMenuItem.gridItemWidth,
                          mainAxisSpacing: itemsSpacing,
                          crossAxisSpacing: itemsSpacing,
                        ),
                        itemBuilder: itemBuilder,
                      ),
                    ],
                  ),
                );
              case ItemsViewMode.list:
                return ListView.separated(
                  padding: EdgeInsets.all(itemsSpacing),
                  itemCount: items.length,
                  itemBuilder: itemBuilder,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: itemsSpacing,
                      top: itemsSpacing,
                      right: itemsSpacing,
                      bottom: index == items.length - 1 ? itemsSpacing : 0,
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
