import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/animation/items_view_mode_button_animation.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSearchBar extends StatelessWidget {
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String placeholder;
  final void Function(String?)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final SearchBoxColorScheme? customColor;

  const ConvertouchSearchBar({
    required this.pageName,
    this.placeholder = "Search...",
    required this.viewModeSettingKey,
    this.onSearchStringChanged,
    this.onSearchReset,
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
          // height: 50,
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
              onSearchStringChanged?.call(value);
            },
            onValueCleaned: onSearchReset,
            colors: searchBarColorScheme.inputBox,
            fontSize: 15,
            borderWidth: 0,
            letterSpacing: 0,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: searchBarColorScheme.inputBox.textBox.foreground.regular,
              size: 22,
            ),
            suffixWidgets: [
              IconButton(
                padding: const EdgeInsets.only(right: 2),
                visualDensity: VisualDensity.compact,
                icon: ConvertouchItemsViewModeButtonAnimation.wrapIntoAnimation(
                  Icon(
                    itemViewModeIconMap[pageViewMode.next],
                    key: ValueKey(pageViewMode),
                    size: 22,
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  BlocProvider.of<AppBloc>(context).add(
                    ChangeSetting(
                      settingKey: viewModeSettingKey,
                      settingValue: pageViewMode.next.value,
                      fromPage: pageName,
                    ),
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
