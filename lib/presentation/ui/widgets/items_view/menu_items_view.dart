import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/text_search_match.dart';
import 'package:flutter/material.dart';

const int _gridItemsNumInRow = 3;
const double _spacing = 8;
const double _bottomSpacing = 85;
const String _defaultSearchPlaceholder = "Search...";
const String _defaultNoItemsLabel = "No Items";

class ConvertouchMenuItemsView<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends StatefulWidget {
  final ItemsListBloc<T, P> itemsListBloc;
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String searchBarPlaceholder;
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
  final ItemsViewMode itemsViewMode;
  final MenuViewColorScheme colors;
  final String noItemsLabel;

  const ConvertouchMenuItemsView({
    required this.itemsListBloc,
    required this.pageName,
    required this.viewModeSettingKey,
    this.searchBarPlaceholder = _defaultSearchPlaceholder,
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
    required this.itemsViewMode,
    required this.colors,
    this.noItemsLabel = _defaultNoItemsLabel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConvertouchMenuItemsViewState<T, P>();
}

class _ConvertouchMenuItemsViewState<T extends IdNameSearchableItemModel,
        P extends ItemsFetchParams>
    extends State<ConvertouchMenuItemsView<T, P>> with ItemsLazyLoadingMixin {
  late final ScrollController _listScrollController;
  late final ScrollController _gridScrollController;

  late double _gridItemWidth;
  late double _gridItemHeight;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _initStateByContext();
      _isInitialized = true;
    }
  }

  void _initStateByContext() {
    double screenWidth = MediaQuery.of(context).size.width;

    _gridItemWidth = ((screenWidth - (_gridItemsNumInRow + 1) * _spacing) /
            _gridItemsNumInRow)
        .roundToDouble();
    _gridItemHeight = _gridItemWidth;

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
        itemHeight: defaultMenuListItemHeight,
        itemsSpacing: _spacing,
        onLoad: onLoadMore,
      );
    });

    _gridScrollController = ScrollController();
    _gridScrollController.addListener(() {
      onScroll(
        controller: _gridScrollController,
        hasReachedMax: widget.itemsListBloc.state.itemsFetch.hasReachedMax,
        itemsNum: widget.itemsListBloc.state.itemsFetch.items.length,
        itemsNumInRow: _gridItemsNumInRow,
        itemHeight: _gridItemHeight,
        itemsSpacing: _spacing,
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

    return itemsListBlocBuilder(
      bloc: widget.itemsListBloc,
      builderFunc: (state) {
        return Column(
          children: [
            ConvertouchSearchBar(
              placeholder: widget.searchBarPlaceholder,
              pageName: widget.pageName,
              viewModeSettingKey: widget.viewModeSettingKey,
              onValueChanged: (text) {
                widget.itemsListBloc.add(
                  FetchItems<P>(
                    searchString: text,
                    params: state.itemsFetch.params,
                  ),
                );
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    List<T> allItems = state.itemsFetch.items;

                    if (allItems.isEmpty) {
                      return Center(
                        child: NoItemsInfoLabel(
                          text: widget.noItemsLabel,
                          colors: widget.colors.noItemsInfoBox,
                        ),
                      );
                    }

                    switch (widget.itemsViewMode) {
                      case ItemsViewMode.list:
                        return ListView.builder(
                          controller: _listScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allItems.length,
                          itemExtent: defaultMenuListItemHeight + _spacing,
                          padding: const EdgeInsets.only(
                            top: _spacing,
                            left: _spacing,
                            right: _spacing,
                            bottom: _bottomSpacing,
                          ),
                          itemBuilder: (context, index) {
                            return _itemBuilder.call(
                              context,
                              item: allItems[index],
                              index: index,
                              itemsNum: allItems.length,
                              itemColors: widget.colors.menuItem,
                              itemsViewMode: widget.itemsViewMode,
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
                            top: _spacing,
                            left: _spacing,
                            right: _spacing,
                            bottom: _bottomSpacing,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _gridItemsNumInRow,
                            crossAxisSpacing: _spacing,
                            mainAxisSpacing: _spacing,
                          ),
                          itemBuilder: (context, index) {
                            return _itemBuilder.call(
                              context,
                              item: allItems[index],
                              index: index,
                              itemsNum: allItems.length,
                              itemColors: widget.colors.menuItem,
                              itemsViewMode: widget.itemsViewMode,
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
    required MenuItemColorScheme itemColors,
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
    }

    onLongPress() {
      widget.onItemLongPress?.call(item);
    }

    switch (itemsViewMode) {
      case ItemsViewMode.list:
        return Padding(
          padding: const EdgeInsets.only(
            bottom: _spacing,
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
          width: _gridItemWidth,
          height: _gridItemHeight,
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
    required double fontSize,
  }) {
    if (item is UnitGroupModel) {
      return FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: IconUtils.getItemLogoIcon(
            iconName: item.iconName,
            color: foreground,
          ),
        ),
      );
    }

    if (item is UnitModel) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: TextSearchMatch(
          sourceString: item.code,
          match: item.codeMatch,
          foreground: foreground,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          matchBackground: matchBackground,
          matchForeground: matchForeground,
        ),
      );
    }

    if (item is ConversionParamSetModel) {
      return FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: IconUtils.getItemLogoIcon(
            iconName: IconNames.parameters,
            color: foreground,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
