import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatelessWidget {
  final List<IdNameItemModel> items;
  final void Function(IdNameItemModel)? onItemTap;
  final void Function(IdNameItemModel)? onItemTapForRemoval;
  final void Function(IdNameItemModel)? onItemLongPress;
  final List<int>? markedItemIds;
  final List<int> itemIdsSelectedForRemoval;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final bool removalModeAllowed;
  final bool removalModeEnabled;
  final bool markItemsOnTap;
  final double itemsSpacing;
  final ItemsViewMode itemsViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.markedItemIds,
    this.itemIdsSelectedForRemoval = const [],
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.removalModeAllowed = false,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    required this.itemsViewMode,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (items.isNotEmpty) {
          if (markedItemIds != null && markedItemIds!.isNotEmpty) {
            print("marked items ids: $markedItemIds");
          }

          Widget? itemBuilder(context, index) {
            IdNameItemModel item = items[index];
            bool selected =
                showSelectedItem && item.id == selectedItemId;
            bool isMarkedToSelect = showMarkedItems &&
                markedItemIds != null &&
                markedItemIds!.contains(item.id);

            if (markedItemIds != null && markedItemIds!.isNotEmpty) {
              print("item with name = ${item.name} is marked = $isMarkedToSelect");
            }

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
                isMarkedToSelect: isMarkedToSelect,
                selected: selected,
                removalMode: removalModeAllowed && removalModeEnabled,
                selectedForRemoval:
                    itemIdsSelectedForRemoval.contains(item.id!),
                markOnTap: markItemsOnTap,
                theme: theme,
              ),
            );
          }

          switch (itemsViewMode) {
            case ItemsViewMode.grid:
              return GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: itemsSpacing,
                  crossAxisSpacing: itemsSpacing,
                ),
                padding: EdgeInsets.all(itemsSpacing),
                itemBuilder: itemBuilder,
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
    );
  }
}
