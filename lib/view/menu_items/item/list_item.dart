import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/item_type.dart';
import 'package:convertouch/model/util/menu_items_util.dart';
import 'package:flutter/material.dart';

class ConvertouchListItem extends StatelessWidget {
  static const double itemContainerHeight = 50;
  static const double itemAbbrContainerWidth = 65;

  const ConvertouchListItem(this.item, {super.key});

  final ItemModel item;

  Widget buildUnitGroupIconButton() {
    return IconButton(
      onPressed: () {},
      icon: ImageIcon(
        AssetImage(getIconPath(item)),
        color: const Color(0xFF366C9F),
        size: 25,
      ),
    );
  }

  Widget buildUnitItemAbbreviation() {
    return Center(
      child: Text(
        toUnit(item).abbreviation,
        style: const TextStyle(
          fontFamily: quicksandFontFamily,
          fontWeight: FontWeight.w700,
          color: Color(0xFF366C9F),
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
              width: item.itemType == ItemType.unitGroup
                  ? itemContainerHeight
                  : itemAbbrContainerWidth,
              decoration: const BoxDecoration(
                color: Color(0x00FFFFFF),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                if (item.itemType == ItemType.unitGroup) {
                  return buildUnitGroupIconButton();
                } else {
                  return buildUnitItemAbbreviation();
                }
              })),
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
    );
  }
}
