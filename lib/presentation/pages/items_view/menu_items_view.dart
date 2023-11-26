import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView extends StatelessWidget {
  final List<IdNameItemModel> items;
  final ConvertouchCommonStateBuilt commonState;
  final void Function(IdNameItemModel)? onItemTap;
  final List<IdNameItemModel>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final bool removalModeAllowed;
  final bool markItemsOnTap;
  final double itemsSpacing;

  const ConvertouchMenuItemsView(
    this.items, {
      required this.commonState,
    this.onItemTap,
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.removalModeAllowed = true,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      if (items.isNotEmpty) {
        Widget? itemBuilder(context, index) {
          IdNameItemModel item = items[index];
          bool selected = showSelectedItem &&
              items[index].id == selectedItemId;
          bool isMarkedToSelect = showMarkedItems &&
              markedItems != null &&
              markedItems!.contains(items[index]);
          return ConvertouchFadeScaleAnimation(
            child: ConvertouchMenuItem(
              item,
              itemsViewMode: ItemsViewMode.grid, //ommonState.pageViewMode!,
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
              theme: commonState.theme,
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
