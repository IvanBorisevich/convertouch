import 'package:flutter/material.dart';

import 'search_bar/search_bar.dart';
import 'items_view/unit_groups.dart';

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  final String appName = 'Convertouch';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Convertouch',
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
    return Material(
      child: Column(
        children: const [
          ConvertouchAppBar(),
          ConvertouchSearchBar(),
          Expanded(
            // child: Center(
            //   child: Text('Hello, world!'),
            // ),
            child: UnitGroupsPage()
          ),
        ],
      ),
    );
  }
}

class ConvertouchAppBar extends StatelessWidget {
  const ConvertouchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Color(0xFFDEE9FF),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            alignment: Alignment.center,
            child: const IconButton(
              icon: Icon(
                Icons.menu,
                color: Color(0xFF426F99),
              ),
              onPressed: null, // null disables the button
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Unit Groups',
                style: TextStyle(
                  color: Color(0xFF426F99),
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Container(
            width: 55,
            alignment: Alignment.center,
            child: const Visibility(
              visible: false,
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color(0xFF426F99),
                ),
                onPressed: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const ConvertouchApp());
}
