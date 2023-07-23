import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem extends StatefulWidget {
  const ConvertouchMenuListItem(this.item, {
    super.key,
    required this.logo,
    this.onTap,
    this.onLongPress,
    this.isMarkedToSelect = false,
    this.isSelected = false,
    this.removalModeEnabled = false,
    this.markOnTap = false,
  });

  final ItemModelWithIdName item;
  final Widget logo;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool isMarkedToSelect;
  final bool isSelected;
  final bool removalModeEnabled;
  final bool markOnTap;

  @override
  State createState() => _ConvertouchMenuListItemState();
}

class _ConvertouchMenuListItemState extends State<ConvertouchMenuListItem> {
  static const double itemContainerHeight = 50;

  late bool _isMarkedToSelect;
  bool _isMarkedToRemove = false;

  @override
  void initState() {
    super.initState();
    _isMarkedToSelect = widget.isMarkedToSelect;
  }

  @override
  Widget build(BuildContext context) {
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

        bool notMarkedAndCanBeSelected = !widget.markOnTap
            && !widget.isMarkedToSelect;
        if (widget.markOnTap || notMarkedAndCanBeSelected) {
          widget.onTap?.call();
        }
      },
      onLongPress: widget.onLongPress,
      child: Container(
        height: itemContainerHeight,
        decoration: BoxDecoration(
          color: widget.isSelected ? const Color(0xFF8BD5FD)
              : (_isMarkedToSelect
              ? const Color(0xFFDEE6FF)
              : const Color(0xFFF2F5FF)
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isMarkedToSelect || widget.isSelected
                ? const Color(0xFF366C9F)
                : const Color(0xFFC9D5EA),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.logo,
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: _isMarkedToSelect || widget.isSelected
                  ? const Color(0xFF366C9F)
                  : const Color(0xFFC9D5EA),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                  child: Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontFamily: quicksandFontFamily,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF366C9F),
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
