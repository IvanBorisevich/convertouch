import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/pages/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatefulWidget {
  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.viewMode = ItemsViewMode.grid,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    super.key,
  });

  final List<IdNameItemModel> items;
  final void Function(IdNameItemModel)? onItemTap;
  final List<IdNameItemModel>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final ItemsViewMode viewMode;
  final bool markItemsOnTap;
  final double itemsSpacing;

  @override
  State createState() => _ConvertouchMenuItemsViewState();
}

class _ConvertouchMenuItemsViewState extends State<ConvertouchMenuItemsView> {
  final List<int> _selectedItemIdsForRemoval = [];
  bool _removalMode = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.items.isNotEmpty) {
        switch (widget.viewMode) {
          case ItemsViewMode.grid:
            return ConvertouchGrid(
              widget.items,
              markedItems: widget.markedItems,
              showMarkedItems: widget.showMarkedItems,
              selectedItemId: widget.selectedItemId,
              selectedItemIdsForRemoval: _selectedItemIdsForRemoval,
              showSelectedItem: widget.showSelectedItem,
              onItemTap: widget.onItemTap,
              removalMode: _removalMode,
              markItemsOnTap: widget.markItemsOnTap,
              itemsSpacing: widget.itemsSpacing,
            );
          case ItemsViewMode.list:
            return ConvertouchList(
              widget.items,
              markedItems: widget.markedItems,
              showMarkedItems: widget.showMarkedItems,
              selectedItemId: widget.selectedItemId,
              selectedItemIdsForRemoval: _selectedItemIdsForRemoval,
              showSelectedItem: widget.showSelectedItem,
              onItemTap: widget.onItemTap,
              removalMode: _removalMode,
              markItemsOnTap: widget.markItemsOnTap,
              itemsSpacing: widget.itemsSpacing,
            );
        }
      }
      return const ConvertouchItemsEmptyView();
    });
  }
}

class ConvertouchGrid extends StatelessWidget {
  final List<IdNameItemModel> items;
  final List<IdNameItemModel>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final List<int>? selectedItemIdsForRemoval;
  final bool showSelectedItem;
  final void Function(IdNameItemModel)? onItemTap;
  final bool removalMode;
  final bool markItemsOnTap;
  final double itemsSpacing;
  final int rowItemsNumber;

  const ConvertouchGrid(
    this.items, {
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.selectedItemIdsForRemoval,
    this.showSelectedItem = false,
    this.onItemTap,
    this.removalMode = false,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    this.rowItemsNumber = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rowItemsNumber,
        mainAxisSpacing: itemsSpacing,
        crossAxisSpacing: itemsSpacing,
      ),
      padding: EdgeInsets.all(itemsSpacing),
      itemBuilder: (context, index) {
        return ConvertouchFadeScaleAnimation(
          child: ConvertouchItem.createItem(
            items[index],
            onTap: () {
              onItemTap?.call(items[index]);
            },
            isMarkedToSelect: showMarkedItems &&
                markedItems != null &&
                markedItems!.contains(items[index]),
            selected: showSelectedItem && items[index].id == selectedItemId,
            removalMode: removalMode,
            markOnTap: markItemsOnTap,
          ).buildForGrid(),
        );
      },
    );
  }
}

class ConvertouchList extends StatelessWidget {
  final List<IdNameItemModel> items;
  final List<IdNameItemModel>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final List<int>? selectedItemIdsForRemoval;
  final bool showSelectedItem;
  final void Function(IdNameItemModel)? onItemTap;
  final bool removalMode;
  final bool markItemsOnTap;
  final double itemsSpacing;

  const ConvertouchList(
    this.items, {
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.selectedItemIdsForRemoval,
    this.showSelectedItem = false,
    this.onItemTap,
    this.removalMode = false,
    this.markItemsOnTap = false,
    this.itemsSpacing = 7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(itemsSpacing),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ConvertouchFadeScaleAnimation(
          child: ConvertouchItem.createItem(
            items[index],
            onTap: () {
              onItemTap?.call(items[index]);
            },
            isMarkedToSelect: showMarkedItems &&
                markedItems != null &&
                markedItems!.contains(items[index]),
            selectedForRemoval:
                selectedItemIdsForRemoval?.contains(items[index].id) ?? false,
            selected: showSelectedItem && items[index].id == selectedItemId,
            removalMode: removalMode,
            markOnTap: markItemsOnTap,
          ).buildForList(),
        );
      },
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

class ConvertouchItemsEmptyView extends StatelessWidget {
  const ConvertouchItemsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
        child: Text(
          "No Items",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
