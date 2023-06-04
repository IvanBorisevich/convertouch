import 'package:convertouch/search_bar/items_view_mode_button.dart';
import 'package:convertouch/search_bar/search_bar_text_field.dart';
import 'package:flutter/material.dart';

class ConvertouchSearchBar extends StatefulWidget {
  const ConvertouchSearchBar({super.key});

  @override
  State createState() => _ConvertouchSearchBarState();
}

class _ConvertouchSearchBarState extends State<ConvertouchSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        decoration: const BoxDecoration(
          color: Color(0xFFDEE9FF),
        ),
        child: Visibility(
            visible: true,
            child: Row(
              children: const [
                ConvertouchSearchBarTextField(),
                ConvertouchItemsViewModeButton()
              ],
            )));
  }
}
