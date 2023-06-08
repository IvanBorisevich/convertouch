import 'package:convertouch/view/search_bar/search_bar_text_field.dart';
import 'package:flutter/material.dart';

class ConvertouchSearchBar extends StatefulWidget {
  const ConvertouchSearchBar(
      {super.key,
      this.listViewModeEnabled = true,
      required this.onViewModeChanged});

  final bool listViewModeEnabled;
  final ValueChanged<bool> onViewModeChanged;

  @override
  State createState() => _ConvertouchSearchBarState();
}

class _ConvertouchSearchBarState extends State<ConvertouchSearchBar> {
  static const double containerHeight = 53;
  static const double elementsSpacing = 5;
  static const double elementsHeight = containerHeight - elementsSpacing;

  void _handleViewModeButtonTap() {
    widget.onViewModeChanged(!widget.listViewModeEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: true,
        child: Container(
          height: containerHeight,
          padding: const EdgeInsets.fromLTRB(
              elementsSpacing, 0, elementsSpacing, elementsSpacing),
          decoration: const BoxDecoration(
            color: Color(0xFFDEE9FF),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ConvertouchSearchBarTextField(),
              const SizedBox(width: elementsSpacing),
              SizedBox(
                width: elementsHeight,
                height: elementsHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F9FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _handleViewModeButtonTap,
                    icon: Icon(
                      widget.listViewModeEnabled
                          ? Icons.grid_view
                          : Icons.list_outlined,
                      color: const Color(0xFF426F99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
