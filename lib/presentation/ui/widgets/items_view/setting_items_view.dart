import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/setting_item.dart';
import 'package:flutter/material.dart';

const double _titleHeight = 40;
const EdgeInsets _titlePadding = EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 10,
);

class ConvertouchSettingItemsView extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final ConvertouchUITheme theme;

  const ConvertouchSettingItemsView({
    required this.title,
    this.items = const [],
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return Column(
      children: [
        Container(
          height: _titleHeight,
          alignment: Alignment.centerLeft,
          padding: _titlePadding,
          child: Text(
            title,
            style: TextStyle(
              color: colors.viewTitle.foreground.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...items.mapIndexed(
          (index, setting) {
            return Column(
              children: [
                setting,
                if (index != items.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class ConvertouchSettingListItemsView<T> extends StatelessWidget {
  final String? title;
  final List<T> values;
  final T? selectedValue;
  final String Function(T) itemTitleMap;
  final void Function(T) onSelect;
  final ConvertouchUITheme theme;

  const ConvertouchSettingListItemsView({
    this.title,
    this.values = const [],
    this.selectedValue,
    required this.itemTitleMap,
    required this.onSelect,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsColorScheme colors = settingItemColors[theme]!;

    return Column(
      children: [
        if (title != null)
          Container(
            height: _titleHeight,
            alignment: Alignment.centerLeft,
            padding: _titlePadding,
            child: Text(
              title!,
              style: TextStyle(
                color: colors.viewTitle.foreground.regular,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ...values.mapIndexed(
          (index, value) {
            return Column(
              children: [
                RadioSettingItem<T>(
                  value: value,
                  title: itemTitleMap.call(value),
                  selectedValue: selectedValue,
                  onSelect: onSelect,
                  theme: theme,
                ),
                if (index != values.length - 1)
                  Container(
                    height: 1,
                    padding: const EdgeInsets.only(left: 48),
                    decoration: BoxDecoration(
                      color: colors.settingItem.background.regular,
                    ),
                    child: Divider(
                      color: colors.divider.regular,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
