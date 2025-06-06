import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/setting_item.dart';
import 'package:flutter/material.dart';

class ConvertouchSettingItemsView extends StatelessWidget {
  final String title;
  final List<ConvertouchSettingItem> settings;
  final double titleHeight;
  final double titleHorizontalPadding;
  final double titleVerticalPadding;
  final ConvertouchUITheme theme;

  const ConvertouchSettingItemsView({
    required this.title,
    this.settings = const [],
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
        Container(
          height: titleHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: titleHorizontalPadding,
            vertical: titleVerticalPadding,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: colors.viewTitle.foreground.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...settings.mapIndexed(
          (index, setting) {
            return Column(
              children: [
                setting,
                if (index != settings.length - 1)
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
