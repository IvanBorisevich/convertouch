import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatefulWidget {
  const ConvertouchMenuGridItem(
    this.item, {
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
  State createState() => _ConvertouchMenuGridItemState();
}

class _ConvertouchMenuGridItemState extends State<ConvertouchMenuGridItem> {
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
        decoration: BoxDecoration(
          color: widget.isSelected ? const Color(0xFF8BD5FD)
            : (_isMarkedToSelect
                ? const Color(0xFFDEE6FF)
                : const Color(0xFFF2F5FF)
          ),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: _isMarkedToSelect || widget.isSelected
                ? const Color(0xFF366C9F)
                : const Color(0xFFC9D5EA),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: widget.logo,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontFamily: quicksandFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF366C9F),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: getGridItemNameLinesNumToWrap(widget.item.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
