import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/keyboard/model/keyboard_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatefulWidget {
  final PageName pageName;
  final String placeholder;
  final SettingKey viewModeSettingKey;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final SearchBarColorScheme? customColor;

  const ConvertouchSearchBar({
    required this.pageName,
    required this.placeholder,
    required this.viewModeSettingKey,
    this.onSearchStringChanged,
    this.onSearchReset,
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
    return appBlocBuilder(builderFunc: (appState) {
      SearchBarColorScheme searchBarColorScheme =
          widget.customColor ?? searchBarColors[appState.theme]!;

      ItemsViewMode pageViewMode =
          widget.viewModeSettingKey == SettingKey.unitGroupsViewMode
              ? appState.unitGroupsViewMode
              : appState.unitsViewMode;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchTextBox(context, searchBarColorScheme.textBox),
          const SizedBox(width: 7),
          _buildViewModeButton(
            context,
            color: searchBarColorScheme.viewModeButton,
            viewModeSettingKey: widget.viewModeSettingKey,
            pageViewMode: pageViewMode,
          ),
        ],
      );
    });
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            inputValueTypeToRegExpMap[ConvertouchValueType.text]!,
          ),
        ],
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
    BuildContext context, {
    required ConvertouchColorScheme color,
    required SettingKey viewModeSettingKey,
    required ItemsViewMode pageViewMode,
  }) {
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
              itemViewModeIconMap[pageViewMode.next],
              key: ValueKey(pageViewMode),
            ),
          ),
          splashColor: noColor,
          highlightColor: noColor,
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(
              ChangeSetting(
                settingKey: viewModeSettingKey.name,
                settingValue: pageViewMode.next.value,
                fromPage: widget.pageName,
              ),
            );
          },
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
