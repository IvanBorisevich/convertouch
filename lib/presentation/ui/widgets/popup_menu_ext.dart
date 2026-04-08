import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ConvertouchPopupMenu extends StatelessWidget {
  static const double _defaultWidth = 200;
  static const double _defaultMaxHeight = 300;

  final List<PopupMenuItemModel?> items;
  final Widget customIcon;
  final double? width;
  final void Function(bool)? onMenuStateChange;
  final DropdownColorScheme colors;

  const ConvertouchPopupMenu({
    required this.items,
    required this.customIcon,
    this.width,
    this.onMenuStateChange,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: IconButton(
          icon: customIcon,
          onPressed: null,
        ),
        onMenuStateChange: onMenuStateChange,
        items: items.nonNulls
            .map(
              (item) => item != PopupMenuItemModel.divider
                  ? DropdownItem<PopupMenuItemModel>(
                      value: item,
                      height: 40,
                      onTap: item.onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          item.iconName != null
                              ? IconUtils.getIcon(
                                  item.iconName!,
                                  color: item.iconColor ?? colors.icon.regular,
                                  size: 24,
                                )
                              : Icon(
                                  item.icon,
                                  color: item.iconColor ?? colors.icon.regular,
                                  size: 24,
                                ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 1),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.text,
                                style: TextStyle(
                                  color: item.textColor ??
                                      colors.foreground.regular,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : DropdownItem<Divider>(
                      enabled: false,
                      height: 12,
                      child: Divider(
                        color: colors.divider.regular,
                      ),
                    ),
            )
            .toList(),
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          width: width ?? _defaultWidth,
          maxHeight: _defaultMaxHeight,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            color: colors.background.regular,
          ),
          openInterval: const Interval(0.25, 0.5, curve: Curves.ease),
        ),
        menuItemStyleData: MenuItemStyleData(
          overlayColor: WidgetStateColor.resolveWith(
            (states) => Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 17),
        ),
      ),
    );
  }
}

class PopupMenuItemModel {
  static const divider = PopupMenuItemModel(text: '');

  final String text;
  final IconData? icon;
  final String? iconName;
  final Color? textColor;
  final Color? iconColor;
  final void Function()? onTap;

  const PopupMenuItemModel({
    required this.text,
    this.icon,
    this.iconName,
    this.textColor,
    this.iconColor,
    this.onTap,
  });
}
