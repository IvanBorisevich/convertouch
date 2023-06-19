import 'package:convertouch/model/menu_view.dart';
import 'package:convertouch/model/util/app_util.dart';
import 'package:convertouch/presenter/bloc/menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/app_bloc.dart';
import 'package:convertouch/presenter/events/menu_view_event.dart';
import 'package:convertouch/presenter/states/menu_view_state.dart';
import 'package:convertouch/presenter/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatelessWidget {
  const ConvertouchSearchBar({super.key});

  static const double _containerHeight = 53;
  static const double _elementsSpacing = 5;
  static const double _elementsHeight = _containerHeight - _elementsSpacing;
  static const int _durationMillis = 150;
  static const double searchTextFieldFontSize = 16;
  static const Map<MenuView, IconData> itemViewModeIconMap = {
    MenuView.list: Icons.list_outlined,
    MenuView.grid: Icons.grid_view_outlined
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        builder: (_, appState) {

      return Visibility(
        visible: appState.isSearchBarVisible,
        child: Container(
          height: _containerHeight,
          padding: const EdgeInsets.fromLTRB(
              _elementsSpacing, 0, _elementsSpacing, _elementsSpacing
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFDEE9FF),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchTextBox(context, appState),
              const SizedBox(width: _elementsSpacing),
              _buildViewModeButton(context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSearchTextBox(BuildContext context, AppState appState) {
    return Expanded(
        child: TextFormField(
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search, color: Color(0xFF7BA2D3)),
            hintText: getSearchBarPlaceholder(appState.pageId),
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
    return BlocBuilder<MenuViewBloc, MenuViewModeState>(
        builder: (_, menuViewModeState) {
      MenuView menuViewMode = menuViewModeState.menuViewMode;
      MenuView nextMenuViewMode = menuViewMode.nextValue();

      return SizedBox(
        width: _elementsHeight,
        height: _elementsHeight,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: _durationMillis),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child)
                );
              },
              child: Icon(itemViewModeIconMap[nextMenuViewMode],
                  key: ValueKey(menuViewMode.modeKey)),
            ),
            onPressed: () {
              BlocProvider.of<MenuViewBloc>(context).add(
                  MenuViewEvent(
                      menuViewMode: nextMenuViewMode
                  )
              );
            },
            color: const Color(0xFF426F99),
          ),
        ),
      );
    });
  }
}
