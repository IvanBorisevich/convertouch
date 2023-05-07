import 'package:convertouch/search_bar/search_bar.dart';
import 'package:flutter/material.dart';

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  final String appName = 'Convertouch';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Convertouch',
        debugShowCheckedModeBanner: false,
        home: SafeArea(
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
            child: Center(
              child: Text('Hello, world!'),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(color: Color(0xFFDEE9FF)),
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
                  fontFamily: 'Poppins',
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
                icon: Icon(Icons.search),
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
