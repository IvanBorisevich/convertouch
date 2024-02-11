import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/menu_item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatelessWidget {
  final List<IdNameItemModel> items;
  final void Function(IdNameItemModel)? onItemTap;
  final void Function(IdNameItemModel)? onItemTapForRemoval;
  final void Function(IdNameItemModel)? onItemLongPress;
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
    this.itemsSpacing = 7,
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
              IdNameItemModel item = items[index];
              bool selected = showSelectedItem && item.id == selectedItemId;
              bool disabled = item.id == disabledItemId;
              bool marked = showMarkedItems &&
                  itemIdsMarkedForConversion != null &&
                  itemIdsMarkedForConversion!.contains(item.id);

              return ConvertouchFadeScaleAnimation(
                child: ConvertouchMenuItem(
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
                ),
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
                    padding: EdgeInsetsDirectional.fromSTEB(
                      itemsSpacing,
                      itemsSpacing,
                      itemsSpacing,
                      index == items.length - 1 ? itemsSpacing : 0,
                    ),
                  ),
                );
            }
          }
          return noItemsView("No menu items found");
        },
      ),
    );
  }
}
