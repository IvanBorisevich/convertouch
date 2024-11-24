import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchItemsListView<T extends IdNameItemModel>
    extends StatefulWidget {
  final ItemsListBloc<T, ItemsFetched<T>> itemsListBloc;
  final void Function() onLoadMore;
  final ListItemColorScheme colors;
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

  const ConvertouchItemsListView({
    required this.itemsListBloc,
    required this.onLoadMore,
    required this.logoFunc,
    required this.colors,
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
  State<StatefulWidget> createState() => _ConvertouchItemsListViewState<T>();
}

class _ConvertouchItemsListViewState<T extends IdNameItemModel>
    extends State<ConvertouchItemsListView<T>> with ItemsLazyLoadingMixin {
  static const double _itemsSpacing = 8;
  static const double _bottomSpacing = 85;

  late final ScrollController _scrollController;
  late final List<T> _itemsFullList;

  @override
  void initState() {
    super.initState();

    _itemsFullList = widget.itemsListBloc.state.pageItems;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      onScroll(
        controller: _scrollController,
        hasReachedMax: widget.itemsListBloc.state.hasReachedMax,
        itemsNum: _itemsFullList.length,
        itemsNumInRow: 1,
        itemHeight: ConvertouchMenuListItem.defaultHeight,
        itemsSpacing: _itemsSpacing,
        onLoad: widget.onLoadMore,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsListBloc<T, ItemsFetched<T>>, ItemsFetched<T>>(
      bloc: widget.itemsListBloc,
      listener: (_, state) {
        setState(() {
          if (state.pageNum <= 1) {
            _itemsFullList.clear();
          }
          _itemsFullList.addAll(state.pageItems);
        });
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemExtent: ConvertouchMenuListItem.defaultHeight + _itemsSpacing,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: _itemsSpacing,
          left: _itemsSpacing,
          right: _itemsSpacing,
          bottom: _bottomSpacing,
        ),
        itemBuilder: (context, index) {
          if (index < _itemsFullList.length) {
            T item = _itemsFullList[index];

            bool selected = item.id == widget.selectedItemId;
            bool disabled = widget.disabledItemIds.contains(item.id);
            bool checked = widget.checkedItemIds.contains(item.id);

            return Padding(
              padding: const EdgeInsets.only(
                bottom: _itemsSpacing,
              ),
              child: ConvertouchMenuListItem(
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
              ),
              // ),
            );
          }
          return null;
        },
      ),
    );
  }
}
