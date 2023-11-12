import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/pages/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView extends StatefulWidget {
  final List<IdNameItemModel> items;
  final void Function(IdNameItemModel)? onItemTap;
  final List<IdNameItemModel>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final ItemsViewMode viewMode;
  final bool markItemsOnTap;
  final double itemsSpacing;

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

  @override
  State createState() => _ConvertouchMenuItemsViewState();
}

class _ConvertouchMenuItemsViewState extends State<ConvertouchMenuItemsView> {
  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return LayoutBuilder(builder: (context, constraints) {
        if (widget.items.isNotEmpty) {
          Widget? itemBuilder(context, index) {
            IdNameItemModel item = widget.items[index];
            bool selected = widget.showSelectedItem &&
                widget.items[index].id == widget.selectedItemId;
            bool isMarkedToSelect = widget.showMarkedItems &&
                widget.markedItems != null &&
                widget.markedItems!.contains(widget.items[index]);
            return ConvertouchFadeScaleAnimation(
              child: ConvertouchMenuItem(
                item,
                itemsViewMode: widget.viewMode,
                onTap: () {
                  widget.onItemTap?.call(item);
                },
                onLongPress: () {
                  if (!appState.removalMode) {
                    BlocProvider.of<AppBloc>(context).add(
                      SelectItemForRemoval(
                        itemId: item.id!,
                      ),
                    );
                  }
                },
                onSelectForRemoval: () {
                  BlocProvider.of<AppBloc>(context).add(
                    SelectItemForRemoval(
                      itemId: item.id!,
                      currentSelectedItemIdsForRemoval:
                          appState.selectedItemIdsForRemoval,
                    ),
                  );
                },
                isMarkedToSelect: isMarkedToSelect,
                selected: selected,
                removalMode: appState.removalMode,
                selectedForRemoval:
                    appState.selectedItemIdsForRemoval.contains(item.id!),
                markOnTap: widget.markItemsOnTap,
              ),
            );
          }

          switch (widget.viewMode) {
            case ItemsViewMode.grid:
              return GridView.builder(
                itemCount: widget.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: widget.itemsSpacing,
                  crossAxisSpacing: widget.itemsSpacing,
                ),
                padding: EdgeInsets.all(widget.itemsSpacing),
                itemBuilder: itemBuilder,
              );
            case ItemsViewMode.list:
              return ListView.separated(
                padding: EdgeInsets.all(widget.itemsSpacing),
                itemCount: widget.items.length,
                itemBuilder: itemBuilder,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    widget.itemsSpacing,
                    widget.itemsSpacing,
                    widget.itemsSpacing,
                    index == widget.items.length - 1 ? widget.itemsSpacing : 0,
                  ),
                ),
              );
          }
        }
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
      });
    });
  }
}
