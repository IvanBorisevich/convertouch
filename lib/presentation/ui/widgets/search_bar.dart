import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatefulWidget {
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String? placeholder;
  final void Function(String?)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final SearchBarColorScheme? customColor;

  const ConvertouchSearchBar({
    required this.pageName,
    this.placeholder,
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
  static const Map<ItemsViewMode, IconData> itemViewModeIconMap = {
    ItemsViewMode.list: Icons.table_rows_rounded,
    ItemsViewMode.grid: Icons.grid_view_rounded,
  };

  final TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(builderFunc: (appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;
      SearchBarColorScheme searchBarColorScheme =
          widget.customColor ?? searchBarColors[appState.theme]!;

      ItemsViewMode pageViewMode =
          widget.viewModeSettingKey == SettingKey.unitGroupsViewMode
              ? appState.unitGroupsViewMode
              : appState.unitsViewMode;

      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: pageColorScheme.appBar.background.regular,
        ),
        padding: const EdgeInsets.only(
          left: 7,
          bottom: 8,
          right: 7,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ConvertouchTextBox(
                controller: _searchFieldController,
                onChanged: widget.onSearchStringChanged,
                hintText: widget.placeholder,
                prefixIcon: Icon(
                  Icons.search,
                  color: searchBarColorScheme.textBox.foreground.regular,
                ),
                suffixIcon: _searchFieldController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          widget.onSearchReset?.call();
                          setState(() {
                            _searchFieldController.clear();
                          });
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
                colors: searchBarColorScheme.textBox,
                contentPadding: const EdgeInsets.symmetric(vertical: 7),
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 7),
            Container(
              width: 43,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: searchBarColorScheme.viewModeButton.background.regular,
              ),
              child: IconButton(
                icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
                  Icon(
                    itemViewModeIconMap[pageViewMode.next],
                    size: 22,
                    key: ValueKey(pageViewMode),
                  ),
                ),
                splashColor: noColor,
                highlightColor: noColor,
                onPressed: () {
                  BlocProvider.of<AppBloc>(context).add(
                    ChangeSetting(
                      settingKey: widget.viewModeSettingKey.name,
                      settingValue: pageViewMode.next.value,
                      fromPage: widget.pageName,
                    ),
                  );
                },
                color: searchBarColorScheme.viewModeButton.foreground.regular,
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }
}
