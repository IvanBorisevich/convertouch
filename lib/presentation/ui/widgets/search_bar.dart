import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchSearchBar extends StatefulWidget {
  final String placeholder;
  final ItemsViewMode pageViewMode;
  final void Function()? onViewModeChange;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final ConvertouchUITheme theme;
  final SearchBarColorScheme? customColor;

  const ConvertouchSearchBar({
    required this.placeholder,
    required this.pageViewMode,
    this.onViewModeChange,
    this.onSearchStringChanged,
    this.onSearchReset,
    required this.theme,
    this.customColor,
    super.key,
  });

  @override
  State createState() => _ConvertouchSearchBarState();
}

class _ConvertouchSearchBarState extends State<ConvertouchSearchBar> {
  static const double searchTextFieldFontSize = 16;
  static const Map<ItemsViewMode, IconData> itemViewModeIconMap = {
    ItemsViewMode.list: Icons.list_outlined,
    ItemsViewMode.grid: Icons.grid_view_outlined
  };

  final TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SearchBarColorScheme searchBarColorScheme =
        widget.customColor ?? searchBarColors[widget.theme]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchTextBox(context, searchBarColorScheme.textBox),
        const SizedBox(width: 6),
        _buildViewModeButton(context, searchBarColorScheme.viewModeButton),
      ],
    );
  }

  Widget _buildSearchTextBox(
    BuildContext context,
    TextBoxColorScheme color,
  ) {
    return Expanded(
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        controller: _searchFieldController,
        onChanged: widget.onSearchStringChanged,
        decoration: InputDecoration(
          suffixIcon: _searchFieldController.text.isEmpty
              ? Icon(
                  Icons.search,
                  color: color.foreground.regular,
                )
              : IconButton(
                  onPressed: () {
                    widget.onSearchReset?.call();
                    setState(() {
                      _searchFieldController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: color.foreground.regular,
                  ),
                ),
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            color: color.hint.regular,
            fontSize: searchTextFieldFontSize,
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: color.background.regular,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        ),
        style: TextStyle(
          color: color.foreground.regular,
          fontSize: searchTextFieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildViewModeButton(
    BuildContext context,
    ConvertouchColorScheme color,
  ) {
    return SizedBox(
      width: 50,
      child: Container(
        decoration: BoxDecoration(
          color: color.background.regular,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
            Icon(
              itemViewModeIconMap[widget.pageViewMode.next],
              key: ValueKey(widget.pageViewMode),
            ),
          ),
          splashColor: noColor,
          highlightColor: noColor,
          onPressed: widget.onViewModeChange,
          color: color.foreground.regular,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }
}
