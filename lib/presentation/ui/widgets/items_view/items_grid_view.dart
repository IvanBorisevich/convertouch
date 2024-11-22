import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/bottom_loader.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsGridView<T extends IdNameItemModel>
    extends StatefulWidget {
  final List<T> items;
  final void Function(ScrollController) onScroll;
  final void Function() onLoadMore;
  final ListItemColorScheme colors;
  final double itemsSpacing;
  final double itemsBottomSpacing;
  final int? selectedItemId;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final String Function(T) itemNameFunc;
  final Widget Function(T, Color) logoFunc;
  final bool removalModeEnabled;
  final bool checkableItemsVisible;
  final bool editableItemsVisible;

  const ConvertouchItemsGridView({
    required this.items,
    required this.onScroll,
    required this.onLoadMore,
    required this.logoFunc,
    required this.colors,
    required this.itemsSpacing,
    required this.itemsBottomSpacing,
    required this.selectedItemId,
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.removalModeEnabled = false,
    this.checkableItemsVisible = false,
    this.editableItemsVisible = false,
    required this.itemNameFunc,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConvertouchItemsGridViewState<T>();
}

class _ConvertouchItemsGridViewState<T extends IdNameItemModel>
    extends State<ConvertouchItemsGridView<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      widget.onScroll.call(_scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: widget.items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: widget.itemsSpacing,
        mainAxisSpacing: widget.itemsSpacing,
      ),
      padding: EdgeInsets.only(
        top: widget.itemsSpacing,
        left: widget.itemsSpacing,
        right: widget.itemsSpacing,
        bottom: widget.itemsBottomSpacing,
      ),
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          T item = widget.items[index];

          bool selected = item.id == widget.selectedItemId;
          bool disabled = widget.disabledItemIds.contains(item.id);
          bool checked = widget.checkedItemIds.contains(item.id);

          return GestureDetector(
            onTap: () {
              if (widget.removalModeEnabled) {
                if (!item.oob) {
                  widget.onItemTapForRemoval?.call(item);
                }
              } else if (!selected && !disabled) {
                FocusScope.of(context).unfocus();
                widget.onItemTap?.call(item);
              }
            },
            onLongPress: () {
              widget.onItemLongPress?.call(item);
            },
            child: ConvertouchMenuGridItem(
              item,
              checked: checked || selected,
              colors: widget.colors,
              disabled: disabled,
              logoFunc: widget.logoFunc,
              itemName: widget.itemNameFunc.call(item),
              checkIconVisible:
                  widget.checkableItemsVisible || widget.removalModeEnabled,
              checkIconVisibleIfUnchecked:
                  !item.oob && widget.removalModeEnabled,
              editIconVisible: !item.oob && widget.editableItemsVisible,
            ),
          );
        } else {
          return BottomLoader(
            onTap: widget.onLoadMore,
            colors: widget.colors,
          );
        }
      },
    );
  }
}
