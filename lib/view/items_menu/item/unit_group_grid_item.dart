import 'package:convertouch/model/util/assets_util.dart';
import 'package:convertouch/model/util/grid_item_util.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupGridItem extends StatelessWidget {
  const ConvertouchUnitGroupGridItem(this.unitGroupName,
      {this.unitGroupIconName = unitGroupDefaultIconName, super.key});

  final String unitGroupName;
  final String unitGroupIconName;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: IconButton(
                onPressed: () {},
                icon: ImageIcon(
                  AssetImage("$iconPathPrefix/$unitGroupIconName"),
                  color: const Color(0xFF366C9F),
                  size: 35,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Center(
                  child: Text(
                    unitGroupName,
                    style: const TextStyle(
                      fontFamily: quicksandFontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF366C9F),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: getLinesNumForItemNameWrapping(unitGroupName),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
