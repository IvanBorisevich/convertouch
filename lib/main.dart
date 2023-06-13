import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/app_bar.dart';
import 'package:convertouch/model/item_view_mode.dart';
import 'package:convertouch/view/converted_units/converted_units_page.dart';
import 'package:convertouch/view/items_menu/items_menu_page.dart';
import 'package:convertouch/view/search_bar.dart';
import 'package:flutter/material.dart';

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  static const String appName = 'Convertouch';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: quicksandFontFamily),
        home: SafeArea(
          child: ConvertouchScaffold(),
        ));
  }
}

class ConvertouchScaffold extends StatefulWidget {
  ConvertouchScaffold({super.key});

  final List<UnitGroupModel> unitGroupItems = [
    UnitGroupModel(1, 'Length'),
    UnitGroupModel(2, 'Area'),
    UnitGroupModel(3, 'Volume'),
    UnitGroupModel(4, 'Speed'),
    UnitGroupModel(5, 'Mass'),
    UnitGroupModel(6, 'Currency'),
    UnitGroupModel(7, 'Temperature'),
    UnitGroupModel(8, 'Numeral System'),
    UnitGroupModel(9, 'Length1 ehuefuhe uehfuehufhe fheufh'),
    UnitGroupModel(10, 'Length1dsdsdsdsddsddsdsdsssd'),
    UnitGroupModel(11, 'Len dd dd'),
    UnitGroupModel(12, 'Length11'),
    UnitGroupModel(13, 'Length'),
    UnitGroupModel(14, 'Length'),
    UnitGroupModel(15, 'Length'),
    UnitGroupModel(16, 'Length'),
    UnitGroupModel(17, 'Length'),
    UnitGroupModel(18, 'Length'),
    UnitGroupModel(19, 'Length'),
    UnitGroupModel(20, 'Length'),
    UnitGroupModel(21, 'Length'),
  ];

  final List<UnitModel> unitItems = [
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'mm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'mm3'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'mm4'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square2 g uygtyfty tyf tyf ygf tyfyt t', 'km/h'),
    UnitModel(3, 'Centimeter Square hhhh hhhhhhhh', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
    UnitModel(1, 'Centimeter', 'cm'),
    UnitModel(2, 'Centimeter Square', 'cm2'),
    UnitModel(3, 'Centimeter Square', 'cm2'),
  ];

  @override
  State<ConvertouchScaffold> createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  ItemViewMode _itemViewMode = ItemViewMode.list;
  bool _isSearchBarVisible = false;
  bool _isFloatingButtonVisible = true;

  final List<UnitValueModel> _convertedItems = [];


  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.unitItems.length; i++) {
      _convertedItems.add(UnitValueModel(widget.unitItems[i], '1'));
    }
  }

  void _handleViewModeChanged(ItemViewMode newValue) {
    setState(() {
      _itemViewMode = newValue;
    });
  }

  void _handleSearchBarVisibility(bool newValue) {
    setState(() {
      _isSearchBarVisible = newValue;
    });
  }

  void _handleFloatingButtonVisibility(bool newValue) {
    setState(() {
      _isFloatingButtonVisible = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const ConvertouchAppBar(),
            Visibility(
                visible: _isSearchBarVisible,
                child: ConvertouchSearchBar(
                    itemViewMode: _itemViewMode,
                    onViewModeChanged: _handleViewModeChanged)),
            Expanded(
                // child: ConvertouchItemsMenuPage(widget.unitItems,
                //     itemViewMode: _itemViewMode)
              child: ConvertouchConvertedUnitsPage(_convertedItems),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: _isFloatingButtonVisible,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ));
  }
}

void main() {
  runApp(const ConvertouchApp());
}
