import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/widgets/bottom_loader.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsReactiveView<T extends IdNameItemModel>
    extends StatefulWidget {
  final ItemsListBloc<T, ItemsFetched<T>> itemsListBloc;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final int? selectedItemId;
  final bool editableItemsVisible;
  final bool checkableItemsVisible;
  final bool removalModeEnabled;
  final ItemsViewMode itemsViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchMenuItemsReactiveView({
    required this.itemsListBloc,
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.selectedItemId,
    this.editableItemsVisible = false,
    this.checkableItemsVisible = false,
    this.removalModeEnabled = false,
    required this.itemsViewMode,
    required this.theme,
    super.key,
  });

  @override
  State<StatefulWidget> createState() =>
      _ConvertouchMenuItemsReactiveViewState<T>();
}

class _ConvertouchMenuItemsReactiveViewState<T extends IdNameItemModel>
    extends State<ConvertouchMenuItemsReactiveView<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return itemsListBlocBuilder(
      bloc: widget.itemsListBloc,
      builderFunc: (itemsState) {
        switch (itemsState.status) {
          case FetchingStatus.failure:
            return const Center(child: Text('Failed to fetch new items'));
          case FetchingStatus.success:
            if (itemsState.items.isEmpty) {
              return const Center(child: Text('No items'));
            }
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 85,
                  ),
                  sliver: SliverGrid.builder(
                    itemCount: itemsState.hasReachedMax
                        ? itemsState.items.length
                        : itemsState.items.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: ConvertouchMenuItem.gridItemHeight,
                      maxCrossAxisExtent: ConvertouchMenuItem.gridItemWidth,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (index < itemsState.items.length) {
                        T item = itemsState.items[index] as T;

                        bool selected = item.id == widget.selectedItemId;
                        bool disabled =
                            widget.disabledItemIds.contains(item.id);
                        bool checked = widget.checkedItemIds.contains(item.id);

                        return ConvertouchMenuItem(
                          item,
                          itemsViewMode: widget.itemsViewMode,
                          onTap: () {
                            if (widget.removalModeEnabled) {
                              if (!item.oob) {
                                widget.onItemTapForRemoval?.call(item);
                              }
                            } else {
                              if (!selected && !disabled) {
                                FocusScope.of(context).unfocus();
                                widget.onItemTap?.call(item);
                              }
                            }
                          },
                          onLongPress: () {
                            widget.onItemLongPress?.call(item);
                          },
                          checked: checked || selected,
                          disabled: disabled,
                          checkIconVisible: widget.checkableItemsVisible ||
                              widget.removalModeEnabled,
                          checkIconVisibleIfUnchecked:
                              !item.oob && widget.removalModeEnabled,
                          editIconVisible:
                              !item.oob && widget.editableItemsVisible,
                          theme: widget.theme,
                        );
                      } else {
                        return const BottomLoader();
                      }
                    },
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    bool hasReachedMax = widget.itemsListBloc.state.hasReachedMax;

    if (!hasReachedMax && _isBottom) {
      widget.itemsListBloc.add(
        const FetchItems(firstFetch: false),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }
}
