import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ConvertouchPopupMenu extends StatelessWidget {
  static const double _defaultWidth = 200;

  final List<PopupMenuItemModel> items;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color highlightColor;
  final double? width;
  final void Function(bool)? onMenuStateChange;

  const ConvertouchPopupMenu({
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.width,
    this.highlightColor = Colors.transparent,
    this.onMenuStateChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: iconColor,
          ),
          onPressed: null,
        ),
        onMenuStateChange: onMenuStateChange,
        items: items
            .map(
              (item) => DropdownMenuItem<PopupMenuItemModel>(
                value: item,
                onTap: item.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    item.iconName != null
                        ? IconUtils.getIcon(
                            item.iconName!,
                            color: item.iconColor ?? iconColor,
                            size: 24,
                          )
                        : Icon(
                            item.icon,
                            color: item.iconColor ?? iconColor,
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
                            color: item.textColor ?? textColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          width: width ?? _defaultWidth,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            color: backgroundColor,
          ),
          openInterval: const Interval(
            0.15,
            0.25,
          ),
          isOverButton: true,
        ),
        menuItemStyleData: MenuItemStyleData(
          overlayColor: WidgetStateColor.resolveWith(
            (states) => highlightColor,
          ),
          customHeights: List.filled(items.length, 40),
          padding: const EdgeInsets.symmetric(horizontal: 17),
        ),
      ),
    );
  }
}

class PopupMenuItemModel {
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
