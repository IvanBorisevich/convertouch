import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_states.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _defaultWidth = 200;
const double _defaultMaxHeight = 300;

class ConvertouchPopupMenu extends StatefulWidget {
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
  State createState() => _ConvertouchPopupMenuState();
}

class _ConvertouchPopupMenuState extends State<ConvertouchPopupMenu> {
  late bool _isMenuOpen;

  @override
  void initState() {
    super.initState();

    _isMenuOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RootScreenBloc, RootScreenState>(
      listener: (_, rootScreenState) {
        if (_isMenuOpen) {
          Navigator.of(context).pop();
        }
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: IconButton(
            icon: widget.customIcon,
            onPressed: null,
          ),
          onMenuStateChange: (isOpen) {
            widget.onMenuStateChange?.call(isOpen);

            setState(() {
              _isMenuOpen = isOpen;
            });
          },
          items: widget.items.nonNulls
              .map(
                (item) => item != PopupMenuItemModel.divider
                    ? DropdownItem<PopupMenuItemModel>(
                        value: item,
                        height: 40,
                        onTap: item.onTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color:
                                  item.iconColor ?? widget.colors.icon.regular,
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
                                        widget.colors.foreground.regular,
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
                          color: widget.colors.divider.regular,
                        ),
                      ),
              )
              .toList(),
          onChanged: (value) {},
          dropdownStyleData: DropdownStyleData(
            width: widget.width ?? _defaultWidth,
            maxHeight: _defaultMaxHeight,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              color: widget.colors.background.regular,
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
      ),
    );
  }
}

class PopupMenuItemModel {
  static const divider = PopupMenuItemModel(text: '');

  final String text;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final void Function()? onTap;

  const PopupMenuItemModel({
    required this.text,
    this.icon,
    this.textColor,
    this.iconColor,
    this.onTap,
  });
}
