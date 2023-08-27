import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem extends StatefulWidget {
  const ConvertouchMenuListItem(
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
  State createState() => _ConvertouchMenuListItemState();
}

class _ConvertouchMenuListItemState extends State<ConvertouchMenuListItem> {
  static const double itemContainerHeight = 50;

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
        if (!widget.isSelected &&
            (widget.markOnTap || notMarkedAndCanBeSelected)) {
          widget.onTap?.call();
        }
      },
      onLongPress: widget.onLongPress,
      child: Container(
        height: itemContainerHeight,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: _contentColor,
                fontWeight: FontWeight.w700,
                fontFamily: quicksandFontFamily,
                fontSize: 16,
              ),
              child: widget.logo,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: _borderColor,
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      fontFamily: quicksandFontFamily,
                      fontWeight: FontWeight.w600,
                      color: _contentColor,
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
    );
  }
}
