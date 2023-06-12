import 'package:convertouch/model/item_view_mode.dart';
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
  static const double _containerHeight = 53;
  static const double _elementsSpacing = 5;
  static const double _elementsHeight = _containerHeight - _elementsSpacing;
  static const int _durationMillis = 110;
  static const Map<ItemViewMode, IconData> itemViewModeIconMap = {
    ItemViewMode.list: Icons.list_outlined,
    ItemViewMode.grid: Icons.grid_view_outlined
  };

  void _handleViewModeButtonTap() {
    widget.onViewModeChanged(widget.itemViewMode.nextValue());
  }

  IconButton buildViewModeButton() {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: _durationMillis),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child));
        },
        child: Icon(itemViewModeIconMap[widget.itemViewMode.nextValue()],
            key: ValueKey(widget.itemViewMode.modeKey)),
      ),
      onPressed: _handleViewModeButtonTap,
      color: const Color(0xFF426F99),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: true,
        child: Container(
          height: _containerHeight,
          padding: const EdgeInsets.fromLTRB(
              _elementsSpacing, 0, _elementsSpacing, _elementsSpacing),
          decoration: const BoxDecoration(
            color: Color(0xFFDEE9FF),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ConvertouchSearchBarTextField(),
              const SizedBox(width: _elementsSpacing),
              SizedBox(
                width: _elementsHeight,
                height: _elementsHeight,
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
