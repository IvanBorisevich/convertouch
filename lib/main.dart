import 'package:convertouch/model/constant/constant.dart';
import 'package:convertouch/model/entity/id_name_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/util/assets_util.dart';
import 'package:convertouch/view/app_bar/app_bar.dart';
import 'package:convertouch/view/items_menu/items_menu.dart';
import 'package:convertouch/view/search_bar/search_bar.dart';
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

  ItemViewMode itemViewMode = ItemViewMode.list;

  final List<IdNameModel> unitGroupItems = [
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

  final List<IdNameModel> unitItems = [
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
    UnitModel(2, 'Centimeter Square guygtyfty tyf tyf ygf tyfyt t', 'km/h'),
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
  void _handleViewModeChanged(ItemViewMode newValue) {
    setState(() {
      widget.itemViewMode = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const ConvertouchAppBar(),
            ConvertouchSearchBar(
                itemViewMode: widget.itemViewMode,
                onViewModeChanged: _handleViewModeChanged),
            Expanded(
                child: ConvertouchItemsMenuPage(
                    widget.unitItems,
                    itemType: ItemModelType.unit,
                    itemViewMode: widget.itemViewMode
                )
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: true,
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
