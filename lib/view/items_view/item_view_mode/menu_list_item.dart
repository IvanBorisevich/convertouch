import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuListItem extends StatelessWidget {
  static const double itemContainerHeight = 50;
  static const double itemAbbrContainerWidth = 65;

  const ConvertouchMenuListItem(this.item, {super.key, required this.logo, this.onPressed});

  final ItemModelWithIdName item;
  final Widget logo;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: itemContainerHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFC9D5EA),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            logo,
            const VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Color(0xFFC9D5EA),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                  child: Text(
                    item.name,
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
