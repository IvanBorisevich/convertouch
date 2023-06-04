import 'package:flutter/material.dart';

class ConvertouchUnitGroupGridItem extends StatelessWidget {
  const ConvertouchUnitGroupGridItem(this.unitGroupName,
      {this.unitGroupIcon = Icons.account_tree_outlined, super.key});

  final String unitGroupName;
  final IconData unitGroupIcon;

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
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0x00FFFFFF),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const ImageIcon(
                AssetImage('icons/unit-group.png'),
                color: Color(0xFF366C9F),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
