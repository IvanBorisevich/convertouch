import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/events/items_menu_view_event.dart';
import 'package:convertouch/view/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/style/model/search_bar_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatelessWidget {
  const ConvertouchSearchBar({
    required this.placeholder,
    required this.colors,
    super.key,
  });

  static const double searchTextFieldFontSize = 16;
  static const Map<ItemsViewMode, IconData> itemViewModeIconMap = {
    ItemsViewMode.list: Icons.list_outlined,
    ItemsViewMode.grid: Icons.grid_view_outlined
  };

  final String placeholder;
  final ConvertouchSearchBarColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchTextBox(context),
        const SizedBox(width: 7),
        _buildViewModeButton(context),
      ],
    );
  }

  Widget _buildSearchTextBox(BuildContext context) {
    return Expanded(
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.search,
            color: colors.searchBoxIconColor,
          ),
          hintText: placeholder,
          hintStyle: TextStyle(
            color: colors.hintColor,
            fontSize: searchTextFieldFontSize,
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: colors.searchBoxFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        ),
        style: TextStyle(
          color: colors.textColor,
          fontSize: searchTextFieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildViewModeButton(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          color: colors.viewModeButtonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: itemsViewModeBloc((itemsMenuViewState) {
          return IconButton(
            icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
              Icon(
                itemViewModeIconMap[itemsMenuViewState.iconViewMode],
                key: ValueKey(itemsMenuViewState.pageViewMode),
              ),
            ),
            onPressed: () {
              BlocProvider.of<ItemsMenuViewBloc>(context).add(
                ChangeViewMode(
                  currentViewMode: itemsMenuViewState.pageViewMode,
                ),
              );
            },
            color: colors.viewModeIconColor,
          );
        }),
      ),
    );
  }
}
