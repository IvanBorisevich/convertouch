import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';

class ConvertouchSearchBar extends StatefulWidget {
  final String placeholder;
  final ItemsViewMode iconViewMode;
  final ItemsViewMode pageViewMode;
  final void Function()? onViewModeChange;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final ConvertouchUITheme theme;
  final ConvertouchSearchBarColor? customColor;

  const ConvertouchSearchBar({
    required this.placeholder,
    required this.iconViewMode,
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
    ConvertouchSearchBarColor color =
        widget.customColor ?? searchBarColors[widget.theme]!;

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
        controller: _searchFieldController,
        onChanged: widget.onSearchStringChanged,
        decoration: InputDecoration(
          suffixIcon: _searchFieldController.text.isEmpty
              ? Icon(
                  Icons.search,
                  color: color.regular.searchBoxIconColor,
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
                    color: color.regular.searchBoxIconColor,
                  ),
                ),
          hintText: widget.placeholder,
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
        child: IconButton(
          icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
            Icon(
              itemViewModeIconMap[widget.iconViewMode],
              key: ValueKey(widget.pageViewMode),
            ),
          ),
          onPressed: widget.onViewModeChange,
          color: color.regular.viewModeIconColor,
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
