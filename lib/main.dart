import 'package:convertouch/app_bar/app_bar.dart';
import 'package:convertouch/items_menu/items_menu.dart';
import 'package:convertouch/search_bar/search_bar.dart';
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
        theme: ThemeData(fontFamily: 'Quicksand'),
        home: const SafeArea(
          child: ConvertouchScaffold(),
        ));
  }
}

class ConvertouchScaffold extends StatelessWidget {
  const ConvertouchScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          ConvertouchAppBar(),
          ConvertouchSearchBar(),
          Expanded(child: UnitGroupsPage()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(const ConvertouchApp());
}
