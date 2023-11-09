import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/pages/scaffold/checkbox.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem extends StatefulWidget {
  final IdNameItemModel item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onSelectForRemoval;
  final void Function()? onDeselectForRemoval;
  final bool isMarkedToSelect;
  final bool selected;
  final bool selectedForRemoval;
  final bool removalMode;
  final bool markOnTap;
  final ConvertouchMenuItemColors? itemColors;

  const ConvertouchMenuItem(
    this.item, {
    this.itemsViewMode = ItemsViewMode.list,
    this.itemColors,
    this.onTap,
    this.onLongPress,
    this.onSelectForRemoval,
    this.onDeselectForRemoval,
    this.isMarkedToSelect = false,
    this.selected = false,
    this.selectedForRemoval = false,
    this.removalMode = false,
    this.markOnTap = false,
    super.key,
  });

  @override
  State<ConvertouchMenuItem> createState() => _ConvertouchMenuItemState();
}

class _ConvertouchMenuItemState extends State<ConvertouchMenuItem> {
  late bool _isMarkedToSelect;
  bool _selectedForRemoval = false;

  late Color _contentColor;
  late Color _borderColor;
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _isMarkedToSelect = widget.isMarkedToSelect;
  }

  @override
  Widget build(BuildContext context) {
    ConvertouchMenuItemColors itemColor;

    if (widget.itemColors != null) {
      itemColor = widget.itemColors!;
    } else if (widget.item.runtimeType == UnitGroupModel) {
      itemColor = unitGroupItemColors[ConvertouchUITheme.light]!;
    } else {
      itemColor = unitItemColors[ConvertouchUITheme.light]!;
    }

    if (widget.selected) {
      _borderColor = itemColor.borderColorSelected;
      _backgroundColor = itemColor.backgroundColorSelected;
      _contentColor = itemColor.contentColorSelected;
    } else if (_isMarkedToSelect) {
      _borderColor = itemColor.borderColorMarked;
      _backgroundColor = itemColor.backgroundColorMarked;
      _contentColor = itemColor.contentColorMarked;
    } else {
      _borderColor = itemColor.borderColor;
      _backgroundColor = itemColor.backgroundColor;
      _contentColor = itemColor.contentColor;
    }

    Widget logo = empty();
    switch (widget.item.runtimeType) {
      case UnitGroupModel:
        UnitGroupModel unitGroup = widget.item as UnitGroupModel;
        logo = IconButton(
          onPressed: null,
          icon: ImageIcon(
            AssetImage(
              "$iconAssetsPathPrefix/${unitGroup.iconName}",
            ),
            color: _contentColor,
            size: 25,
          ),
        );
        break;
      case UnitModel:
        UnitModel unit = widget.item as UnitModel;
        logo = SizedBox(
          width: 65,
          child: Center(
            child: Text(
              unit.abbreviation,
            ),
          ),
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        if (widget.removalMode) {
          setState(() {
            _selectedForRemoval = !_selectedForRemoval;
          });
        } else {
          if (!widget.selected) {
            if (widget.markOnTap) {
              setState(() {
                _isMarkedToSelect = !_isMarkedToSelect;
              });
            }
          }
        }

        bool notMarkedAndCanBeSelected =
            !widget.markOnTap && !widget.isMarkedToSelect;
        if (!widget.selected &&
            (widget.markOnTap || notMarkedAndCanBeSelected)) {
          widget.onTap?.call();
        }
      },
      onLongPress: widget.onLongPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          switch (widget.itemsViewMode) {
            case ItemsViewMode.grid:
              return ConvertouchMenuGridItem(
                widget.item,
                logo: logo,
                borderColor: _borderColor,
                contentColor: _contentColor,
                backgroundColor: _backgroundColor,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                widget.item,
                logo: logo,
                borderColor: _borderColor,
                contentColor: _contentColor,
                backgroundColor: _backgroundColor,
              );
          }
        },
      ),
    );
  }
}

class ConvertouchMenuListItem extends StatelessWidget {
  final IdNameItemModel item;
  final Widget logo;
  final double itemContainerHeight;
  final bool selectedForRemoval;
  final Color borderColor;
  final Color contentColor;
  final Color backgroundColor;

  const ConvertouchMenuListItem(
    this.item, {
    required this.logo,
    this.itemContainerHeight = 50,
    required this.borderColor,
    required this.contentColor,
    required this.backgroundColor,
    this.selectedForRemoval = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemContainerHeight,
      child: Row(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 6),
          //   child: ConvertouchCheckbox(
          //     selectedForRemoval,
          //     color: borderColor,
          //     colorChecked: contentColor,
          //   ),
          // ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: quicksandFontFamily,
                      fontSize: 16,
                    ),
                    child: logo,
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    color: borderColor,
                  ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontFamily: quicksandFontFamily,
                            fontWeight: FontWeight.w600,
                            color: contentColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConvertouchMenuGridItem extends StatelessWidget {
  final IdNameItemModel item;
  final Widget logo;
  final bool selectedForRemoval;
  final Color borderColor;
  final Color contentColor;
  final Color backgroundColor;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.logo,
    required this.borderColor,
    required this.contentColor,
    required this.backgroundColor,
    this.selectedForRemoval = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: DefaultTextStyle(
              style: TextStyle(
                color: contentColor,
                fontWeight: FontWeight.w700,
                fontFamily: quicksandFontFamily,
                fontSize: 16,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: logo,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
              child: Text(
                item.name,
                style: TextStyle(
                  fontFamily: quicksandFontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: contentColor,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: _getGridItemNameLinesNumToWrap(item.name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;

int _getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}
