import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_bloc.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_event.dart';
import 'package:convertouch/presentation/pages/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatelessWidget {
  static const double searchTextFieldFontSize = 16;
  static const Map<ItemsViewMode, IconData> itemViewModeIconMap = {
    ItemsViewMode.list: Icons.list_outlined,
    ItemsViewMode.grid: Icons.grid_view_outlined
  };

  final String placeholder;
  final ConvertouchUITheme theme;
  final ConvertouchSearchBarColor? customColor;

  const ConvertouchSearchBar({
    required this.placeholder,
    this.theme = ConvertouchUITheme.light,
    this.customColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConvertouchSearchBarColor color = customColor ?? searchBarColor[theme]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchTextBox(context, color),
        const SizedBox(width: 7),
        _buildViewModeButton(context, color),
      ],
    );
  }

  Widget _buildSearchTextBox(
    BuildContext context,
    ConvertouchSearchBarColor color,
  ) {
    return Expanded(
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.search,
            color: color.regular.searchBoxIconColor,
          ),
          hintText: placeholder,
          hintStyle: TextStyle(
            color: color.regular.hintColor,
            fontSize: searchTextFieldFontSize,
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: color.regular.searchBoxFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        ),
        style: TextStyle(
          color: color.regular.textColor,
          fontSize: searchTextFieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildViewModeButton(
    BuildContext context,
    ConvertouchSearchBarColor color,
  ) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          color: color.regular.viewModeButtonColor,
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
            color: color.regular.viewModeIconColor,
          );
        }),
      ),
    );
  }
}
