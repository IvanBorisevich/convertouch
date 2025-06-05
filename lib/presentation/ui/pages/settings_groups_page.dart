import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/setting_list_items_view.dart';
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
                  theme: appState.theme,
                  itemTitleMap: (v) => v.value,
                  values: ConvertouchUITheme.values,
                  selectedValue: appState.theme,
                  onSelect: (newValue) {
                    BlocProvider.of<AppBloc>(context).add(
                      ChangeSetting(
                        settingKey: SettingKey.theme.name,
                        settingValue: newValue.value,
                      ),
                    );
                  },
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
