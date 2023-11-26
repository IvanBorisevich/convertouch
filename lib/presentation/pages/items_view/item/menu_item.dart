import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/scaffold/checkbox.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItem extends StatefulWidget {
  final IdNameItemModel item;
  final ItemsViewMode itemsViewMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onSelectForRemoval;
  final bool isMarkedToSelect;
  final bool selected;
  final bool removalMode;
  final bool selectedForRemoval;
  final bool markOnTap;
  final ConvertouchUITheme theme;
  final ConvertouchMenuItemColor? color;

  const ConvertouchMenuItem(
    this.item, {
    this.itemsViewMode = ItemsViewMode.list,
    this.onTap,
    this.onLongPress,
    this.onSelectForRemoval,
    this.isMarkedToSelect = false,
    this.selected = false,
    this.removalMode = false,
    this.selectedForRemoval = false,
    this.markOnTap = false,
    required this.theme,
    this.color,
    super.key,
  });

  @override
  State<ConvertouchMenuItem> createState() => _ConvertouchMenuItemState();
}

class _ConvertouchMenuItemState extends State<ConvertouchMenuItem> {
  late MenuItemColorVariation _color;
  late bool _isMarkedToSelect;

  @override
  void initState() {
    super.initState();
    _isMarkedToSelect = widget.isMarkedToSelect;
  }

  @override
  Widget build(BuildContext context) {
    ConvertouchMenuItemColor itemColor;

    if (widget.color != null) {
      itemColor = widget.color!;
    } else if (widget.item.runtimeType == UnitGroupModel) {
      itemColor = unitGroupItemColors[widget.theme]!;
    } else {
      itemColor = unitItemColors[widget.theme]!;
    }

    if (widget.selected) {
      _color = itemColor.selected;
    } else if (_isMarkedToSelect) {
      _color = itemColor.marked;
    } else {
      _color = itemColor.regular;
    }

    Widget logo = IconButton(
      onPressed: null,
      icon: ImageIcon(
        const AssetImage(
          "$iconAssetsPathPrefix/$unitGroupDefaultIconName",
        ),
        color: _color.content,
        size: 25,
      ),
    );

    switch (widget.item.runtimeType) {
      case UnitGroupModel:
        UnitGroupModel unitGroup = widget.item as UnitGroupModel;
        logo = IconButton(
          onPressed: null,
          icon: ImageIcon(
            AssetImage(
              "$iconAssetsPathPrefix/${unitGroup.iconName}",
            ),
            color: _color.content,
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
          widget.onSelectForRemoval?.call();
        } else {
          if (!widget.selected) {
            if (widget.markOnTap) {
              setState(() {
                _isMarkedToSelect = !_isMarkedToSelect;
              });
            }
          }

          bool notMarkedAndCanBeSelected =
              !widget.markOnTap && !widget.isMarkedToSelect;
          if (!widget.selected &&
              (widget.markOnTap || notMarkedAndCanBeSelected)) {
            widget.onTap?.call();
          }
        }
      },
      onLongPress: widget.onLongPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          switch (widget.itemsViewMode) {
            case ItemsViewMode.grid:
              return ConvertouchMenuGridItem(
                widget.item,
                removalMode: widget.removalMode,
                selectedForRemoval: widget.selectedForRemoval,
                selectedForConversion: widget.selected,
                logo: logo,
                color: _color,
              );
            case ItemsViewMode.list:
              return ConvertouchMenuListItem(
                widget.item,
                removalMode: widget.removalMode,
                selectedForRemoval: widget.selectedForRemoval,
                selectedForConversion: widget.selected,
                logo: logo,
                color: _color,
              );
          }
        },
      ),
    );
  }
}

class ConvertouchMenuListItem extends StatelessWidget {
  final IdNameItemModel item;
  final bool removalMode;
  final Widget logo;
  final double itemContainerHeight;
  final bool selectedForRemoval;
  final bool selectedForConversion;
  final MenuItemColorVariation color;

  const ConvertouchMenuListItem(
    this.item, {
    required this.removalMode,
    required this.logo,
    this.itemContainerHeight = 50,
    required this.color,
    this.selectedForRemoval = false,
    this.selectedForConversion = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemContainerHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  strokeAlign: selectedForConversion
                      ? BorderSide.strokeAlignOutside
                      : BorderSide.strokeAlignInside,
                  color: color.border,
                  width: selectedForConversion ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  removalMode
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ConvertouchCheckbox(
                            selectedForRemoval,
                            color: color.border,
                            colorChecked: color.content,
                          ),
                        )
                      : empty(),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: color.content,
                      fontWeight: FontWeight.w700,
                      fontFamily: quicksandFontFamily,
                      fontSize: 16,
                    ),
                    child: logo,
                  ),
                  VerticalDivider(
                    width: selectedForConversion ? 3 : 1,
                    thickness: selectedForConversion ? 2 : 1,
                    indent: 5,
                    endIndent: 5,
                    color: color.border,
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
                            color: color.content,
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
  final bool removalMode;
  final Widget logo;
  final bool selectedForRemoval;
  final bool selectedForConversion;
  final MenuItemColorVariation color;

  const ConvertouchMenuGridItem(
    this.item, {
    required this.removalMode,
    required this.logo,
    required this.color,
    this.selectedForRemoval = false,
    this.selectedForConversion = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.background,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          strokeAlign: selectedForConversion
              ? BorderSide.strokeAlignOutside
              : BorderSide.strokeAlignInside,
          color: color.border,
          width: selectedForConversion ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: Stack(
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: color.content,
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
                removalMode
                    ? Padding(
                        padding: const EdgeInsets.only(left: 3, top: 3),
                        child: ConvertouchCheckbox(
                          selectedForRemoval,
                          size: 12,
                          color: color.border,
                          colorChecked: color.content,
                        ),
                      )
                    : empty(),
              ],
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
                  color: color.content,
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
