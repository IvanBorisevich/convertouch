import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/settings_controller.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';

const Map<ItemsViewMode, IconData> _itemViewModeIconMap = {
  ItemsViewMode.list: Icons.reorder_outlined,
  ItemsViewMode.grid: Icons.grid_view_rounded,
};

class ConvertouchSearchBar extends StatelessWidget {
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String placeholder;
  final void Function(String)? onValueChanged;
  final SearchBoxColorScheme? customColor;

  const ConvertouchSearchBar({
    required this.pageName,
    this.placeholder = "Search...",
    required this.viewModeSettingKey,
    this.onValueChanged,
    this.customColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColorScheme = appColors[appState.theme].page;
        SearchBoxColorScheme searchBarColorScheme =
            customColor ?? appColors[appState.theme].searchBox;

        ItemsViewMode pageViewMode;

        if (viewModeSettingKey == SettingKey.unitGroupsViewMode) {
          pageViewMode = appState.unitGroupsViewMode;
        } else if (viewModeSettingKey == SettingKey.unitsViewMode) {
          pageViewMode = appState.unitsViewMode;
        } else if (viewModeSettingKey == SettingKey.paramSetsViewMode) {
          pageViewMode = appState.paramSetsViewMode;
        } else {
          pageViewMode = ItemsViewMode.grid;
        }

        return Container(
          decoration: BoxDecoration(
            color: pageColorScheme.appBar.background.regular,
          ),
          padding: const EdgeInsets.only(
            left: 7,
            bottom: 8,
            right: 7,
          ),
          child: ConvertouchInputBox(
            model: TextBoxModel(
              hint: placeholder,
              hintUnfocused: placeholder,
            ),
            onValueChanged: (value) {
              onValueChanged?.call(value);
            },
            colors: searchBarColorScheme.inputBox,
            fontSize: 15,
            borderWidth: 0,
            inputFieldMargin: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              right: 7,
            ),
            prefixWidgets: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Icon(
                  Icons.search,
                  color:
                      searchBarColorScheme.inputBox.textBox.foreground.regular,
                  size: 22,
                ),
              ),
            ],
            prefixRightmostDividerVisible: false,
            suffixWidgets: [
              IconButton(
                padding: const EdgeInsets.only(right: 2),
                visualDensity: VisualDensity.compact,
                icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
                  Icon(
                    _itemViewModeIconMap[pageViewMode.next],
                    key: ValueKey(pageViewMode),
                    size: 22,
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  settingsController.changeSetting(
                    context,
                    key: viewModeSettingKey,
                    newValue: pageViewMode.next.value,
                    fromPage: pageName,
                  );
                },
                color: searchBarColorScheme.viewModeButton.foreground.regular,
              ),
            ],
          ),
        );
      },
    );
  }
}
