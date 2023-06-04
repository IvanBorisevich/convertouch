import 'package:flutter/material.dart';

import 'package:convertouch/items_menu/view_mode/items_grid.dart';

class UnitGroupsPage extends StatefulWidget {
  const UnitGroupsPage({super.key});

  final List<String> unitGroupNames = const <String>[
    'Length',
    'Area',
    'Volume',
    'Speed',
    'Mass',
    'Currency',
    'Temperature',
    'Numeral System',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length2'
  ];

  @override
  State<UnitGroupsPage> createState() => _UnitGroupsPageState();
}

class _UnitGroupsPageState extends State<UnitGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F9FF),
          ),
          child: ConvertouchItemsGrid(widget.unitGroupNames) //ConvertouchItemsList(widget.unitGroupNames)
      ),
    );
  }
}
