import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchListBox extends StatefulWidget {
  final ListBoxModel model;
  final FocusNode? focusNode;
  final bool autofocus;
  final void Function(ListValueModel?)? onValueChanged;
  final BorderRadius borderRadius;
  final double borderWidth;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double contentPaddingLeft;
  final double contentPaddingRight;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? labelPadding;
  final double labelFontSize;

  const ConvertouchListBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.onValueChanged,
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    this.borderWidth = 1,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPaddingLeft = InputBoxConstants.defaultContentPaddingLeft,
    this.contentPaddingRight = InputBoxConstants.defaultContentPaddingRight,
    this.height = InputBoxConstants.defaultHeight,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.labelPadding,
    this.labelFontSize = InputBoxConstants.defaultLabelFontSize,
    super.key,
  });

  @override
  State<ConvertouchListBox> createState() => _ConvertouchListBoxState();
}

class _ConvertouchListBoxState extends State<ConvertouchListBox>
    with ItemsLazyLoadingMixin, FocusNodeMixin {
  final TextEditingController _dropdownSearchController =
      TextEditingController();

  late bool _isDropdownOpen;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _isDropdownOpen = false;

    _focusNode = initOrGetFocusNode(widget.focusNode);

    super.initState();
  }

  @override
  void dispose() {
    disposeFocusNode(
      focusNode: _focusNode,
    );
    _dropdownSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color foregroundColor;
    Color hintColor;
    WidgetColorScheme dropdownMenu = widget.colors.dropdown;

    if (widget.model.readonly) {
      borderColor = widget.colors.textBox.border.disabled;
      foregroundColor = widget.colors.textBox.foreground.disabled;
      hintColor = widget.colors.textBox.hint.disabled;
    } else if (_focusNode.hasFocus) {
      borderColor = widget.colors.textBox.border.focused;
      foregroundColor = widget.colors.textBox.foreground.focused;
      hintColor = widget.colors.textBox.hint.focused;
    } else {
      borderColor = widget.colors.textBox.border.regular;
      foregroundColor = widget.colors.textBox.foreground.regular;
      hintColor = widget.colors.textBox.hint.regular;
    }

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isDropdownOpen) {
          Navigator.of(context).pop();
        }
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<ListValueModel>(
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: widget.borderWidth > 0
                  ? BorderSide(
                      color: borderColor,
                      width: widget.borderWidth,
                    )
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: widget.borderWidth > 0
                  ? BorderSide(
                      color: borderColor,
                      width: widget.borderWidth,
                    )
                  : BorderSide.none,
            ),
            contentPadding: EdgeInsets.only(
              top: widget.height / 2,
              left: widget.contentPaddingLeft,
              right: widget.contentPaddingRight,
            ),
            isDense: true,
            label: Container(
              padding: widget.labelPadding,
              decoration: BoxDecoration(
                color: widget.colors.textBox.background.regular,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Text(
                widget.model.labelText,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: widget.labelFontSize,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()..color = borderColor,
                ),
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: widget.colors.textBox.background.regular,
          ),
          hint: Text(
            widget.model.hint,
            style: TextStyle(
              fontSize: 16,
              color: hintColor,
            ),
          ),
          value: widget.model.value,
          items: widget.model.listValues
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      value.itemName,
                      style: TextStyle(
                        fontSize: 16,
                        color: dropdownMenu.foreground.regular,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onValueChanged,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            fontFamily: quicksandFontFamily,
          ),
          /*
        selectedItemBuilder is used as a workaround in order to align paddings between
        DropdownButtonFormField2, its label over the border and DropdownMenuItem
         */
          selectedItemBuilder: (context) {
            return widget.model.listValues.map(
              (value) {
                return Container(
                  padding: EdgeInsets.zero,
                  child: Text(
                    widget.model.value?.itemName ?? widget.model.hint,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      foreground: Paint()..color = foregroundColor,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.expand_more_rounded,
              color: foregroundColor,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            scrollbarTheme: ScrollbarThemeData(
              thickness: WidgetStateProperty.all(4),
              thumbColor: WidgetStateProperty.all(
                dropdownMenu.foreground.regular,
              ),
              trackColor: WidgetStateProperty.all(Colors.transparent),
              trackBorderColor: WidgetStateProperty.all(Colors.transparent),
              trackVisibility: WidgetStateProperty.all(true),
              radius: const Radius.circular(10),
            ),
            maxHeight: 250,
            elevation: 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(17)),
              color: dropdownMenu.background.regular,
            ),
            padding: EdgeInsets.zero,
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
          ),
          dropdownSearchData: widget.model.searchEnabled
              ? DropdownSearchData(
                  searchController: _dropdownSearchController,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ConvertouchTextBox(
                      model: TextBoxModel(
                        hintUnfocused: widget.model.searchHint,
                        valueType: widget.model.listType.listValuesType,
                      ),
                      controller: _dropdownSearchController,
                      borderWidth: 0,
                      fontSize: 15,
                      colors: widget.colors,
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value?.value
                            .toLowerCase()
                            .contains(searchValue.toLowerCase()) ??
                        false;
                  },
                )
              : null,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _dropdownSearchController.clear();
            }

            setState(() {
              _isDropdownOpen = isOpen;
            });
          },
        ),
      ),
    );
  }
}
