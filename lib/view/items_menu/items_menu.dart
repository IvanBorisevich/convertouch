import 'package:convertouch/view/items_menu/item_view_mode/items_list.dart';
import 'package:convertouch/view/items_menu/item_view_mode/items_grid.dart';
import 'package:flutter/material.dart';

class UnitItemsMenuPage extends StatefulWidget {
  const UnitItemsMenuPage({super.key, this.listViewModeEnabled = true});

  final List<String> unitGroupNames = const <String>[
    'Length',
    'Area',
    'Volume',
    'Speed',
    'Mass',
    'Currency',
    'Temperature',
    'Numeral System',
    'Length1 ehuefuhe uehfuehufhe fheufh',
    'Length1dsdsdsdsddsddsdsdsssd',
    'Len dd dd',
    'Length1',
    'Length1',
    'Length1',
    'Length2',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length2',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length2',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length2',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length1',
    'Length2'
  ];

  final bool listViewModeEnabled;

  @override
  State<UnitItemsMenuPage> createState() => _UnitItemsMenuPageState();
}

class _UnitItemsMenuPageState extends State<UnitItemsMenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F9FF),
          ),
          child: widget.listViewModeEnabled
              ? ConvertouchItemsList(widget.unitGroupNames)
              : ConvertouchItemsGrid(widget.unitGroupNames)),
    );
  }
}
