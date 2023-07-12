import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuGridItem extends StatelessWidget {
  const ConvertouchMenuGridItem(this.item, {
    super.key,
    required this.logo,
    this.onPressed,
    this.itemNameMaxLines,
  });

  final ItemModelWithIdName item;
  final Widget logo;
  final void Function()? onPressed;
  final int? itemNameMaxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFC9D5EA),
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
                child: logo,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: quicksandFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF366C9F),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: itemNameMaxLines,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
