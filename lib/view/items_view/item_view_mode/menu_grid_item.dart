import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatefulWidget {
  const ConvertouchMenuGridItem(
    this.item, {
    super.key,
    required this.logo,
    this.onPressed,
    this.isSelected = false,
    this.changeItemStateOnPress = false,
  });

  final ItemModelWithIdName item;
  final Widget logo;
  final void Function()? onPressed;
  final bool isSelected;
  final bool changeItemStateOnPress;

  @override
  State createState() => _ConvertouchMenuGridItemState();
}

class _ConvertouchMenuGridItemState extends State<ConvertouchMenuGridItem> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.changeItemStateOnPress) {
          setState(() {
            _isSelected = !_isSelected;
          });
        }
        widget.onPressed?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              _isSelected ? const Color(0xFFDEE6FF) : const Color(0xFFF2F5FF),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color:
                _isSelected ? const Color(0xFF366C9F) : const Color(0xFFC9D5EA),
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
