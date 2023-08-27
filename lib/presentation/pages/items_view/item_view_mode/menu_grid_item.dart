import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatefulWidget {
  const ConvertouchMenuGridItem(
    this.item, {
    super.key,
    required this.logo,
    required this.itemColors,
    this.onTap,
    this.onLongPress,
    this.isMarkedToSelect = false,
    this.isSelected = false,
    this.removalModeEnabled = false,
    this.markOnTap = false,
  });

  final IdNameItemModel item;
  final Widget logo;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool isMarkedToSelect;
  final bool isSelected;
  final bool removalModeEnabled;
  final bool markOnTap;
  final ConvertouchMenuItemColors itemColors;

  @override
  State createState() => _ConvertouchMenuGridItemState();
}

class _ConvertouchMenuGridItemState extends State<ConvertouchMenuGridItem> {
  late bool _isMarkedToSelect;
  bool _isMarkedToRemove = false;

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
    var itemColor = widget.itemColors;
    if (widget.isSelected) {
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

    return GestureDetector(
      onTap: () {
        if (widget.removalModeEnabled) {
          setState(() {
            _isMarkedToRemove = !_isMarkedToRemove;
          });
        } else {
          if (!widget.isSelected) {
            if (widget.markOnTap) {
              setState(() {
                _isMarkedToSelect = !_isMarkedToSelect;
              });
            }
          }
        }

        bool notMarkedAndCanBeSelected =
            !widget.markOnTap && !widget.isMarkedToSelect;
        if (widget.markOnTap || notMarkedAndCanBeSelected) {
          widget.onTap?.call();
        }
      },
      onLongPress: widget.onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: _contentColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: quicksandFontFamily,
                  fontSize: 16,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: widget.logo,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Text(
                  widget.item.name,
                  style: TextStyle(
                    fontFamily: quicksandFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _contentColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: _getGridItemNameLinesNumToWrap(widget.item.name),
                ),
              ),
            ),
          ],
        ),
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
