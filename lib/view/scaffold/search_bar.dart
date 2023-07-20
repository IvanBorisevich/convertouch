import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/events/items_menu_view_event.dart';
import 'package:convertouch/view/animation/items_menu_animation.dart';
import 'package:convertouch/view/scaffold/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatelessWidget {
  const ConvertouchSearchBar({required this.placeholder, super.key});

  static const double _containerHeight = 53;
  static const double _elementsSpacing = 5;
  static const double _elementsHeight = _containerHeight - _elementsSpacing;
  static const double searchTextFieldFontSize = 16;
  static const Map<ItemsMenuViewMode, IconData> itemViewModeIconMap = {
    ItemsMenuViewMode.list: Icons.list_outlined,
    ItemsMenuViewMode.grid: Icons.grid_view_outlined
  };

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.fromLTRB(
          _elementsSpacing, 0, _elementsSpacing, _elementsSpacing),
      decoration: const BoxDecoration(
        color: Color(0xFFDEE9FF),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchTextBox(context),
          const SizedBox(width: _elementsSpacing),
          _buildViewModeButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchTextBox(BuildContext context) {
    return Expanded(
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search, color: Color(0xFF7BA2D3)),
          hintText: placeholder,
          hintStyle: const TextStyle(
              color: Color(0xFF7BA2D3), fontSize: searchTextFieldFontSize),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: const Color(0xFFF6F9FF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        ),
        style: const TextStyle(
          color: Color(0xFF426F99),
          fontSize: searchTextFieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildViewModeButton(BuildContext context) {
    return SizedBox(
      width: _elementsHeight,
      height: _elementsHeight,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F9FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: wrapIntoItemsMenuViewBloc((itemsMenuViewState) {
          return IconButton(
            icon: ConvertouchItemsMenuAnimation.wrapIntoAnimation(Icon(
                itemViewModeIconMap[itemsMenuViewState.iconViewMode],
                key: ValueKey(itemsMenuViewState.pageViewMode))),
            onPressed: () {
              BlocProvider.of<ItemsMenuViewBloc>(context)
                  .add(ChangeViewMode(currentViewMode: itemsMenuViewState.pageViewMode));
            },
            color: const Color(0xFF426F99),
          );
        }),
      ),
    );
  }
}
