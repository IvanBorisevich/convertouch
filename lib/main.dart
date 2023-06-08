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
        home: const SafeArea(
          child: ConvertouchScaffold(),
        ));
  }
}

class ConvertouchScaffold extends StatefulWidget {
  const ConvertouchScaffold({super.key});

  @override
  State<ConvertouchScaffold> createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  bool _listViewModeEnabled = true;

  void _handleViewModeChanged(bool newValue) {
    setState(() {
      _listViewModeEnabled = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const ConvertouchAppBar(),
            ConvertouchSearchBar(
                listViewModeEnabled: _listViewModeEnabled,
                onViewModeChanged: _handleViewModeChanged),
            Expanded(
                child: UnitItemsMenuPage(
                    listViewModeEnabled: _listViewModeEnabled)),
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
