import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/setting_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/setting_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSettingsPage extends StatelessWidget {
  const ConvertouchSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        return ConvertouchPage(
          title: "Settings",
          body: SingleChildScrollView(
            child: Column(
              children: [
                ConvertouchSettingListItemsView<ConvertouchUITheme>(
                  title: "Theme",
                  itemTitleMap: (v) => v.value,
                  values: ConvertouchUITheme.values,
                  selectedValue: appState.theme,
                  theme: appState.theme,
                  onSelect: (newValue) {
                    BlocProvider.of<AppBloc>(context).add(
                      ChangeSetting(
                        settingKey: SettingKey.theme,
                        settingValue: newValue.value,
                      ),
                    );
                  },
                ),
                ConvertouchSettingItemsView(
                  title: "Conversion Page",
                  items: [
                    SelectorSettingItem<UnitTapAction>(
                      title: "Unit Tap Action",
                      selectedValue: appState.unitTapAction,
                      valueMap: (v) => v.value,
                      possibleValues: UnitTapAction.values,
                      theme: appState.theme,
                      onPossibleValueSelect: (newValue) {
                        BlocProvider.of<AppBloc>(context).add(
                          ChangeSetting(
                            settingKey: SettingKey.conversionUnitTapAction,
                            settingValue: newValue.id,
                          ),
                        );
                      },
                    ),
                    SelectorSettingItem<RecalculationOnUnitChange>(
                      title: "Recalculation On Unit Change",
                      selectedValue: appState.recalculationOnUnitChange,
                      valueMap: (v) => v.value,
                      possibleValues: RecalculationOnUnitChange.values,
                      theme: appState.theme,
                      onPossibleValueSelect: (newValue) {
                        BlocProvider.of<AppBloc>(context).add(
                          ChangeSetting(
                            settingKey: SettingKey.recalculationOnUnitChange,
                            settingValue: newValue.id,
                          ),
                        );
                      },
                    ),
                    SwitcherSettingItem(
                      title: "Keep Params On Conversion Cleanup",
                      value: true,
                      theme: appState.theme,
                      onSwitch: (newValue) {
                        print("new switcher value = $newValue");
                      },
                    ),
                  ],
                  theme: appState.theme,
                ),
                ConvertouchSettingItemsView(
                  title: "About",
                  theme: appState.theme,
                  items: [
                    AboutSettingItem(
                      title: "App Version",
                      value: appState.appVersion,
                      theme: appState.theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: null,
        );
      },
    );
  }
}
