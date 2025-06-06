import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/setting_list_item.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingListItemsView<T> extends StatelessWidget {
  final String? title;
  final List<T> values;
  final T? selectedValue;
  final String Function(T) itemTitleMap;
  final void Function(T) onSelect;
  final double titleHeight;
  final double titleHorizontalPadding;
  final double titleVerticalPadding;
  final ConvertouchUITheme theme;

  const ConvertouchSettingListItemsView({
    this.title,
    this.values = const [],
    this.selectedValue,
    required this.itemTitleMap,
    required this.onSelect,
    this.titleHeight = 40,
    this.titleHorizontalPadding = 18,
    this.titleVerticalPadding = 10,
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
            height: titleHeight,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: titleHorizontalPadding,
              vertical: titleVerticalPadding,
            ),
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
                ConvertouchSettingListItem<T>(
                  value: value,
                  title: itemTitleMap.call(value),
                  selectedValue: selectedValue,
                  onChange: onSelect,
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
