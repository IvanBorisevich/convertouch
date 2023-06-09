import 'package:convertouch/view/items_menu/item_view_mode/item_view_mode.dart';
import 'package:convertouch/view/search_bar/search_bar_text_field.dart';
import 'package:flutter/material.dart';

class ConvertouchSearchBar extends StatefulWidget {
  const ConvertouchSearchBar(
      {super.key,
      this.itemViewMode = ItemViewMode.list,
      required this.onViewModeChanged});

  final ItemViewMode itemViewMode;
  final ValueChanged<ItemViewMode> onViewModeChanged;

  @override
  State createState() => _ConvertouchSearchBarState();
}

class _ConvertouchSearchBarState extends State<ConvertouchSearchBar> {
  static const double containerHeight = 53;
  static const double elementsSpacing = 5;
  static const double elementsHeight = containerHeight - elementsSpacing;

  void _handleViewModeButtonTap() {
    widget.onViewModeChanged(widget.itemViewMode.nextValue());
  }

  IconButton buildViewModeButton() {
    return IconButton(
      icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child)
            );
          },
          child: Icon(widget.itemViewMode.nextModeIcon,
              key: widget.itemViewMode.modeKey)),
      onPressed: _handleViewModeButtonTap,
      color: const Color(0xFF426F99),
    );
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
                  child: buildViewModeButton(),
                ),
              ),
            ],
          ),
        ));
  }
}
