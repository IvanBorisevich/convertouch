import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatelessWidget {
  final List<IdNameItemModel> items;
  final void Function(IdNameItemModel)? onItemTap;
  final List<int>? markedItemIds;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final bool removalModeAllowed;
  final bool markItemsOnTap;
  final double itemsSpacing;
  final ConvertouchUITheme theme;

  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.markedItemIds,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.removalModeAllowed = true,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (items.isNotEmpty) {
        Widget? itemBuilder(context, index) {
          IdNameItemModel item = items[index];
          bool selected = showSelectedItem && items[index].id == selectedItemId;
          bool isMarkedToSelect = showMarkedItems &&
              markedItemIds != null &&
              markedItemIds!.contains(items[index].id);
          return ConvertouchFadeScaleAnimation(
            child: ConvertouchMenuItem(
              item,
              itemsViewMode: ItemsViewMode.grid,
              onTap: () {
                onItemTap?.call(item);
              },
              onLongPress: () {
                // if (removalModeAllowed && !pageState.removalMode) {
                //   BlocProvider.of<ConvertouchCommonBloc>(context).add(
                //     SelectMenuItemForRemoval(
                //       item: item,
                //       currentPageId: pageState.pageId!,
                //       startPageIndex: pageState.startPageIndex,
                //     ),
                //   );
                // }
              },
              onSelectForRemoval: () {
                // BlocProvider.of<ConvertouchCommonBloc>(context).add(
                //   SelectMenuItemForRemoval(
                //     item: item,
                //     currentPageId: pageState.pageId!,
                //     startPageIndex: pageState.startPageIndex,
                //     selectedItemIdsForRemoval: pageState.selectedItemIdsForRemoval,
                //   ),
                // );
              },
              isMarkedToSelect: isMarkedToSelect,
              selected: selected,
              // removalMode: pageState.removalMode,
              // selectedForRemoval:
              //   pageState.selectedItemIdsForRemoval.contains(item.id!),
              markOnTap: markItemsOnTap,
              theme: theme,
            ),
          );
        }

        var v = ItemsViewMode.grid;

        switch (v) {
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
    });
  }
}
