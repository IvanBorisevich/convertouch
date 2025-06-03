import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/text_search_match.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends StatefulWidget {
  final ItemsListBloc<T, P> itemsListBloc;
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String? searchBarPlaceholder;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final int? selectedItemId;
  final bool editableItemsVisible;
  final bool checkableItemsVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool removalModeEnabled;

  const ConvertouchMenuItemsView({
    required this.itemsListBloc,
    required this.pageName,
    required this.viewModeSettingKey,
    this.searchBarPlaceholder,
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.selectedItemId,
    this.editableItemsVisible = false,
    this.checkableItemsVisible = false,
    this.checkIconVisibleIfUnchecked = false,
    this.removalModeEnabled = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConvertouchMenuItemsViewState<T, P>();
}

class _ConvertouchMenuItemsViewState<T extends IdNameSearchableItemModel,
        P extends ItemsFetchParams>
    extends State<ConvertouchMenuItemsView<T, P>> with ItemsLazyLoadingMixin {
  static const double _itemsSpacing = 8;
  static const double _bottomSpacing = 85;

  late Map<ConvertouchUITheme, ListItemColorScheme> _itemColors;
  late Map<ConvertouchUITheme, ConvertouchColorScheme> _emptyViewColors;
  late final ScrollController _listScrollController;
  late final ScrollController _gridScrollController;

  late final String _noItemsLabel;

  @override
  void initState() {
    super.initState();

    if (T == UnitGroupModel) {
      _itemColors = unitGroupItemColors;
      _emptyViewColors = unitGroupPageEmptyViewColor;
      _noItemsLabel = "Unit groups list is empty";
    } else if (T == UnitModel) {
      _itemColors = unitItemColors;
      _emptyViewColors = unitPageEmptyViewColor;
      _noItemsLabel = "Units list is empty";
    } else {
      _itemColors = paramSetItemColors;
      _emptyViewColors = paramSetPageEmptyViewColor;
      _noItemsLabel = "Parameters list is empty";
    }

    onLoadMore() {
      widget.itemsListBloc.add(
        FetchItems<P>(firstFetch: false),
      );
    }

    _listScrollController = ScrollController();
    _listScrollController.addListener(() {
      onScroll(
        controller: _listScrollController,
        hasReachedMax: widget.itemsListBloc.state.itemsFetch.hasReachedMax,
        itemsNum: widget.itemsListBloc.state.itemsFetch.items.length,
        itemsNumInRow: 1,
        itemHeight: ConvertouchMenuListItem.defaultHeight,
        itemsSpacing: _itemsSpacing,
        onLoad: onLoadMore,
      );
    });

    _gridScrollController = ScrollController();
    _gridScrollController.addListener(() {
      onScroll(
        controller: _gridScrollController,
        hasReachedMax: widget.itemsListBloc.state.itemsFetch.hasReachedMax,
        itemsNum: widget.itemsListBloc.state.itemsFetch.items.length,
        itemsNumInRow: 4,
        itemHeight: ConvertouchMenuGridItem.defaultHeight,
        itemsSpacing: _itemsSpacing,
        onLoad: onLoadMore,
      );
    });
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _gridScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkIconVisible =
        widget.checkableItemsVisible || widget.removalModeEnabled;

    if (T == UnitGroupModel) {
      _itemColors = unitGroupItemColors;
      _emptyViewColors = unitGroupPageEmptyViewColor;
    } else if (T == UnitModel) {
      _itemColors = unitItemColors;
      _emptyViewColors = unitPageEmptyViewColor;
    } else {
      _itemColors = paramSetItemColors;
      _emptyViewColors = paramSetPageEmptyViewColor;
    }

    return itemsListBlocBuilder(
      bloc: widget.itemsListBloc,
      builderFunc: (state) {
        return Column(
          children: [
            ConvertouchSearchBar(
              placeholder: widget.searchBarPlaceholder,
              pageName: widget.pageName,
              viewModeSettingKey: widget.viewModeSettingKey,
              onSearchStringChanged: (text) {
                widget.itemsListBloc.add(
                  FetchItems<P>(
                    searchString: text,
                    params: state.itemsFetch.params,
                  ),
                );
              },
              onSearchReset: () {
                widget.itemsListBloc.add(
                  FetchItems(
                    params: state.itemsFetch.params,
                  ),
                );
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: appBlocBuilder(
                  builderFunc: (appState) {
                    List<T> allItems = state.itemsFetch.items;

                    if (allItems.isEmpty) {
                      return Center(
                        child: NoItemsInfoLabel(
                          text: _noItemsLabel,
                          colors: _emptyViewColors[appState.theme]!,
                        ),
                      );
                    }

                    var itemColors = _itemColors[appState.theme]!;

                    ItemsViewMode itemsViewMode;

                    if (T == UnitGroupModel) {
                      itemsViewMode = appState.unitGroupsViewMode;
                    } else if (T == UnitModel) {
                      itemsViewMode = appState.unitsViewMode;
                    } else {
                      itemsViewMode = appState.paramSetsViewMode;
                    }

                    switch (itemsViewMode) {
                      case ItemsViewMode.list:
                        return ListView.builder(
                          controller: _listScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allItems.length,
                          itemExtent: ConvertouchMenuListItem.defaultHeight +
                              _itemsSpacing,
                          padding: const EdgeInsets.only(
                            top: _itemsSpacing,
                            left: _itemsSpacing,
                            right: _itemsSpacing,
                            bottom: _bottomSpacing,
                          ),
                          itemBuilder: (context, index) {
                            return _itemBuilder.call(
                              context,
                              item: allItems[index],
                              index: index,
                              itemsNum: allItems.length,
                              itemColors: itemColors,
                              itemsViewMode: itemsViewMode,
                              checkIconVisible: checkIconVisible,
                            );
                          },
                        );
                      case ItemsViewMode.grid:
                        return GridView.builder(
                          controller: _gridScrollController,
                          itemCount: allItems.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: _itemsSpacing,
                            left: _itemsSpacing,
                            right: _itemsSpacing,
                            bottom: _bottomSpacing,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: _itemsSpacing,
                            mainAxisSpacing: _itemsSpacing,
                          ),
                          itemBuilder: (context, index) {
                            return _itemBuilder.call(
                              context,
                              item: allItems[index],
                              index: index,
                              itemsNum: allItems.length,
                              itemColors: itemColors,
                              itemsViewMode: itemsViewMode,
                              checkIconVisible: checkIconVisible,
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget? _itemBuilder(
    BuildContext context, {
    required T item,
    required int index,
    required int itemsNum,
    required ListItemColorScheme itemColors,
    required ItemsViewMode itemsViewMode,
    required bool checkIconVisible,
  }) {
    if (index >= itemsNum) {
      return null;
    }

    bool selected = item.id == widget.selectedItemId;
    bool disabled = widget.disabledItemIds.contains(item.id);
    bool checked = widget.checkedItemIds.contains(item.id);
    bool checkIconVisibleIfUnchecked = !disabled &&
        (widget.checkIconVisibleIfUnchecked ||
            !item.oob && widget.removalModeEnabled);
    bool editIconVisible = !item.oob && widget.editableItemsVisible;

    onTap() {
      _onItemTap(
        context,
        item,
        callable: !selected && !disabled,
      );
    }

    onLongPress() {
      widget.onItemLongPress?.call(item);
    }

    switch (itemsViewMode) {
      case ItemsViewMode.list:
        return Padding(
          padding: const EdgeInsets.only(
            bottom: _itemsSpacing,
          ),
          child: ConvertouchMenuListItem(
            item,
            checked: checked || selected,
            colors: itemColors,
            disabled: disabled,
            logoFunc: _logo,
            checkIconVisible: checkIconVisible,
            checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
            editIconVisible: editIconVisible,
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        );
      case ItemsViewMode.grid:
        return ConvertouchMenuGridItem(
          item,
          checked: checked || selected,
          colors: itemColors,
          disabled: disabled,
          logoFunc: _logo,
          checkIconVisible: checkIconVisible,
          checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
          editIconVisible: editIconVisible,
          onTap: onTap,
          onLongPress: onLongPress,
        );
    }
  }

  Widget _logo(
    T item, {
    required Color foreground,
    required Color matchForeground,
    required Color matchBackground,
  }) {
    if (item is UnitGroupModel) {
      return IconUtils.getUnitGroupIcon(
        iconName: item.iconName,
        color: foreground,
        size: 29,
      );
    }

    if (item is UnitModel) {
      return TextSearchMatch(
        sourceString: item.code,
        match: item.codeMatch,
        foreground: foreground,
        fontSize: 17,
        matchBackground: matchBackground,
        matchForeground: matchForeground,
      );
    }

    if (item is ConversionParamModel) {
      return IconUtils.getUnitGroupIcon(
        iconName: IconNames.parameters,
        color: foreground,
        size: 29,
      );
    }

    return const SizedBox.shrink();
  }

  void _onItemTap(
    BuildContext context,
    T item, {
    bool callable = true,
  }) {
    if (widget.removalModeEnabled) {
      if (!item.oob) {
        widget.onItemTapForRemoval?.call(item);
      }
    } else {
      if (callable) {
        FocusScope.of(context).unfocus();
        widget.onItemTap?.call(item);
      }
    }
  }
}
