import 'package:flutter/material.dart';

class ConvertouchUnitGroupListItem extends StatelessWidget {
  const ConvertouchUnitGroupListItem(this.unitGroupName,
      {this.unitGroupIcon = Icons.account_tree_outlined, super.key});

  final String unitGroupName;
  final IconData unitGroupIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFC9D5EA),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 50,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0x00FFFFFF),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                unitGroupIcon,
                color: const Color(0xFF366C9F),
                size: 25,
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: Color(0xFFC9D5EA),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0x00FFFFFF),
              ),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Text(
                    unitGroupName,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF366C9F),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
